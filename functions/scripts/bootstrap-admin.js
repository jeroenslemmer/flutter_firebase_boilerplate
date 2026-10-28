// Uses Application Default Credentials. Never put service account keys in this repository.
import {initializeApp} from 'firebase-admin/app';
import {getAuth} from 'firebase-admin/auth';
import {getFirestore, FieldValue} from 'firebase-admin/firestore';
const [projectId, uid] = process.argv.slice(2);
if (!projectId || !uid || uid.includes('/')) throw new Error('Usage: npm run bootstrap -- PROJECT_ID UID');
initializeApp({projectId});
const auth = getAuth(), db = getFirestore();
const user = await auth.getUser(uid);
if (user.disabled || !user.emailVerified) throw new Error('Use an active account with a verified email.');
await db.runTransaction(async tx => {
  const ref = db.doc(`adminAccess/${uid}`), previous = await tx.get(ref);
  tx.set(ref, {role: 'admin', updatedAt: FieldValue.serverTimestamp()});
  tx.create(db.collection('adminAudit').doc(), {action: 'admin.bootstrap', targetUid: uid,
    actorUid: 'trusted-operator', before: previous.data()?.role ?? 'user', after: 'admin',
    at: FieldValue.serverTimestamp()});
});
await auth.setCustomUserClaims(uid, {...user.customClaims, role: 'admin'});
console.log('Admin assigned. Sign in again.');
