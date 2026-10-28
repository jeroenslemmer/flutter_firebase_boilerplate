import {initializeApp} from 'firebase-admin/app';
import {getAuth} from 'firebase-admin/auth';
import {getFirestore, FieldValue} from 'firebase-admin/firestore';
import {onCall, HttpsError} from 'firebase-functions/v2/https';
import {roles, roleOf, canManage, profilePatch} from './policy.js';
initializeApp();
const auth = getAuth(), db = getFirestore();
const access = uid => db.collection('adminAccess').doc(uid);
const fail = (code, message) => {throw new HttpsError(code, message);};
const options = {region: 'europe-west1', maxInstances: 5};
function uidOf(value) {
  if (typeof value !== 'string' || !value.length || value.length > 128 || value.includes('/')) {
    fail('invalid-argument', 'Ongeldige UID.');
  }
  return value;
}
async function identity(request) {
  if (!request.auth) fail('unauthenticated', 'Log opnieuw in.');
  const user = await auth.getUser(request.auth.uid);
  if (user.disabled || !user.emailVerified ||
      request.auth.token.auth_time * 1000 < Date.parse(user.tokensValidAfterTime)) {
    fail('permission-denied', 'Een actief, geverifieerd account is vereist. Log opnieuw in.');
  }
  return user.uid;
}
async function manager(request) {
  const uid = await identity(request);
  const role = roleOf(await access(uid).get());
  if (role === 'user') fail('permission-denied', 'Geen beheerrechten.');
  return {uid, role};
}
function account(user, role) {
  return {uid: user.uid, email: user.email ?? '', emailVerified: user.emailVerified,
    disabled: user.disabled, role, providers: user.providerData.map(p => p.providerId),
    createdAt: user.metadata.creationTime, lastSignIn: user.metadata.lastSignInTime ?? null};
}
export const adminSession = onCall(options, async request => manager(request));
export const adminListUsers = onCall(options, async request => {
  await manager(request);
  const {search = '', pageToken} = request.data ?? {};
  if (typeof search !== 'string' || search.length > 320 ||
      (pageToken !== undefined && (typeof pageToken !== 'string' || pageToken.length > 4096))) {
    fail('invalid-argument', 'Ongeldige zoekopdracht.');
  }
  let users, nextPageToken;
  if (search.trim()) {
    try {
      const query = search.trim();
      users = [await (query.includes('@') ? auth.getUserByEmail(query) : auth.getUser(uidOf(query)))];
    } catch (error) {
      if (error.code === 'auth/user-not-found') users = []; else throw error;
    }
  } else {
    const result = await auth.listUsers(25, pageToken);
    users = result.users; nextPageToken = result.pageToken;
  }
  const docs = users.length ? await db.getAll(...users.map(u => access(u.uid))) : [];
  // Managers never receive privileged accounts, including via direct UID lookup.
  const actor = await manager(request);
  return {users: users.map((u, i) => account(u, roleOf(docs[i])))
    .filter(u => canManage(actor.role, u.role)), nextPageToken: nextPageToken ?? null};
});
export const adminGetUser = onCall(options, async request => {
  const actor = await manager(request), uid = uidOf(request.data?.uid);
  const [user, roleDoc, profile] = await Promise.all([
    auth.getUser(uid), access(uid).get(), db.doc(`users/${uid}`).get()]);
  const role = roleOf(roleDoc);
  if (!canManage(actor.role, role)) fail('permission-denied', 'Je mag dit account niet beheren.');
  const data = profile.data();
  return {user: account(user, role), profile: data ? {
    language: data.language, themeMode: data.themeMode, profileComplete: data.profileComplete,
    createdAt: data.createdAt?.toDate().toISOString() ?? null,
    lastLogin: data.lastLogin?.toDate().toISOString() ?? null,
  } : null};
});
export const adminUpdateProfile = onCall(options, async request => {
  const actorUid = await identity(request), uid = uidOf(request.data?.uid);
  let patch;
  try {patch = profilePatch(request.data?.profile);} catch {fail('invalid-argument', 'Ongeldige profielvelden.');}
  await auth.getUser(uid);
  const log = db.collection('adminAudit').doc();
  await db.runTransaction(async tx => {
    const [actor, target, profile] = await tx.getAll(access(actorUid), access(uid), db.doc(`users/${uid}`));
    if (!canManage(roleOf(actor), roleOf(target))) fail('permission-denied', 'Geen toegang tot dit profiel.');
    if (!profile.exists) fail('not-found', 'Dit account heeft nog geen appprofiel.');
    tx.update(profile.ref, patch);
    tx.create(log, {actorUid, targetUid: uid, action: 'profile.update',
      before: {language: profile.data().language, themeMode: profile.data().themeMode,
        profileComplete: profile.data().profileComplete}, after: patch, at: FieldValue.serverTimestamp()});
  });
  return {ok: true};
});
export const adminSetRole = onCall(options, async request => {
  const actorUid = await identity(request), uid = uidOf(request.data?.uid), role = request.data?.role;
  if (!roles.includes(role)) fail('invalid-argument', 'Onbekende rol.');
  await auth.getUser(uid);
  await db.runTransaction(async tx => {
    const [actor, target] = await tx.getAll(access(actorUid), access(uid));
    if (roleOf(actor) !== 'admin') fail('permission-denied', 'Alleen admins mogen rollen wijzigen.');
    if (uid === actorUid) fail('failed-precondition', 'Laat een andere admin jouw rol wijzigen.');
    if (target.data()?.statusPending) fail('failed-precondition', 'Er staat nog een accountactie open.');
    const oldRole = roleOf(target);
    if (oldRole === 'admin' && role !== 'admin') {
      const admins = await tx.get(db.collection('adminAccess').where('role', '==', 'admin'));
      if (admins.size <= 1) fail('failed-precondition', 'De laatste admin moet behouden blijven.');
    }
    tx.set(access(uid), {role, updatedAt: FieldValue.serverTimestamp()});
    tx.create(db.collection('adminAudit').doc(), {actorUid, targetUid: uid,
      action: 'role.update', before: oldRole, after: role, at: FieldValue.serverTimestamp()});
  });
  // adminAccess is authoritative, including when synchronizing the token fails.
  try {
    const user = await auth.getUser(uid);
    await auth.setCustomUserClaims(uid, {...user.customClaims, role});
    return {ok: true, claimsSynced: true};
  } catch {
    return {ok: true, claimsSynced: false};
  }
});
export const adminSetDisabled = onCall(options, async request => {
  const actorUid = await identity(request), uid = uidOf(request.data?.uid), disabled = request.data?.disabled;
  if (typeof disabled !== 'boolean') fail('invalid-argument', 'Ongeldige accountstatus.');
  if (uid === actorUid) fail('failed-precondition', 'Je kunt je eigen account niet blokkeren.');
  // Privileged accounts must first be demoted. This also prevents blocking the last admin.
  const log = db.collection('adminAudit').doc();
  await db.runTransaction(async tx => {
    const [actor, target] = await tx.getAll(access(actorUid), access(uid));
    if (!canManage(roleOf(actor), roleOf(target)) || roleOf(target) !== 'user') {
      fail('permission-denied', 'Alleen gewone gebruikers kunnen worden geblokkeerd.');
    }
    if (target.data()?.statusPending) fail('failed-precondition', 'Er staat nog een accountactie open.');
    // Lock role changes while the external Auth operation is pending.
    tx.set(access(uid), {role: 'user', statusPending: true}, {merge: true});
    tx.create(log, {actorUid, targetUid: uid, action: 'account.disabled', disabled,
      status: 'pending', at: FieldValue.serverTimestamp()});
  });
  try {
    await auth.updateUser(uid, {disabled});
    if (disabled) await auth.revokeRefreshTokens(uid);
    const batch = db.batch();
    batch.update(access(uid), {statusPending: FieldValue.delete()});
    batch.update(log, {status: 'completed', completedAt: FieldValue.serverTimestamp()});
    await batch.commit();
  } catch {
    // Preserve the pending record: an Auth change may have succeeded. Never report success.
    fail('internal', 'Actie mogelijk gedeeltelijk uitgevoerd. Controleer accountstatus en het beheerlogboek voordat je opnieuw probeert.');
  }
  return {ok: true};
});
