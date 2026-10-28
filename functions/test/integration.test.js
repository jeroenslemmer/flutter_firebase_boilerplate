import assert from 'node:assert/strict';
import {before, test} from 'node:test';
import {getAuth} from 'firebase-admin/auth';
import {getFirestore, Timestamp} from 'firebase-admin/firestore';
import * as api from '../index.js';
const enabled = !!process.env.FIRESTORE_EMULATOR_HOST && !!process.env.FIREBASE_AUTH_EMULATOR_HOST;
const integration = (name, fn) => test(name, {skip: !enabled}, fn);
const auth = getAuth(), db = getFirestore();
const request = (uid, data = {}) => ({auth: {uid, token: {auth_time: Math.floor(Date.now() / 1000) + 2}}, data});
const denied = fn => assert.rejects(fn, e => ['permission-denied', 'failed-precondition', 'unauthenticated'].includes(e.code));
before(async () => {
  if (!enabled) return;
  if (!process.env.GCLOUD_PROJECT?.startsWith('demo-')) throw new Error('Tests require a demo project.');
  for (const uid of ['admin', 'manager', 'ordinary', 'unverified', 'disabled']) {
    try {await auth.deleteUser(uid);} catch (e) {if (e.code !== 'auth/user-not-found') throw e;}
    await auth.createUser({uid, email: `${uid}@example.com`, password: 'Test-password-42!',
      emailVerified: uid !== 'unverified', disabled: uid === 'disabled'});
    await db.doc(`adminAccess/${uid}`).delete();
  }
  await db.doc('adminAccess/admin').set({role: 'admin'});
  await db.doc('adminAccess/manager').set({role: 'user-manager'});
  await db.doc('adminAccess/unverified').set({role: 'admin'});
  await db.doc('adminAccess/disabled').set({role: 'admin'});
  await db.doc('users/ordinary').set({createdAt: Timestamp.now(), lastLogin: Timestamp.now(),
    language: 'nl', themeMode: 'system', profileComplete: false});
});
integration('unauthenticated, ordinary, unverified and disabled actors cannot enter', async () => {
  await denied(() => api.adminSession.run({data: {}}));
  for (const uid of ['ordinary', 'unverified', 'disabled']) await denied(() => api.adminSession.run(request(uid)));
});
integration('manager list and exact lookup do not disclose privileged users', async () => {
  const list = await api.adminListUsers.run(request('manager'));
  assert.ok(list.users.some(u => u.uid === 'ordinary'));
  assert.ok(list.users.every(u => u.role === 'user'));
  assert.deepEqual((await api.adminListUsers.run(request('manager', {search: 'admin'}))).users, []);
  await denied(() => api.adminGetUser.run(request('manager', {uid: 'admin'})));
});
integration('manager updates only allowed profile fields and logs the action', async () => {
  const before = (await db.doc('users/ordinary').get()).data();
  await api.adminUpdateProfile.run(request('manager', {uid: 'ordinary', profile: {
    language: 'fr', themeMode: 'dark', profileComplete: true}}));
  const after = (await db.doc('users/ordinary').get()).data();
  assert.equal(after.language, 'fr'); assert.ok(after.createdAt.isEqual(before.createdAt));
  assert.ok(after.lastLogin.isEqual(before.lastLogin));
  const logs = await db.collection('adminAudit').where('action', '==', 'profile.update').get();
  assert.ok(logs.docs.some(d => d.data().actorUid === 'manager' && d.data().targetUid === 'ordinary'));
});
integration('ordinary user and manager cannot elevate roles', async () => {
  for (const uid of ['ordinary', 'manager']) await denied(() => api.adminSetRole.run(request(uid, {uid: 'ordinary', role: 'admin'})));
  await denied(() => api.adminSetRole.run(request('admin', {uid: 'admin', role: 'user'})));
});
integration('admin role changes take effect despite a stale token', async () => {
  const oldRequest = request('manager');
  await api.adminSetRole.run(request('admin', {uid: 'manager', role: 'user'}));
  await denied(() => api.adminSession.run(oldRequest));
  await api.adminSetRole.run(request('admin', {uid: 'manager', role: 'user-manager'}));
});
integration('manager can block and unblock ordinary user with completed audit', async () => {
  await api.adminSetDisabled.run(request('manager', {uid: 'ordinary', disabled: true}));
  assert.equal((await auth.getUser('ordinary')).disabled, true);
  await api.adminSetDisabled.run(request('manager', {uid: 'ordinary', disabled: false}));
  assert.equal((await auth.getUser('ordinary')).disabled, false);
  assert.equal((await db.doc('adminAccess/ordinary').get()).data().statusPending, undefined);
});
integration('privileged accounts and own account cannot be blocked', async () => {
  await denied(() => api.adminSetDisabled.run(request('manager', {uid: 'admin', disabled: true})));
  await denied(() => api.adminSetDisabled.run(request('admin', {uid: 'admin', disabled: true})));
});
integration('pending Auth operation prevents role change and duplicate status operation', async () => {
  await db.doc('adminAccess/ordinary').set({role: 'user', statusPending: true});
  await denied(() => api.adminSetRole.run(request('admin', {uid: 'ordinary', role: 'admin'})));
  await denied(() => api.adminSetDisabled.run(request('admin', {uid: 'ordinary', disabled: true})));
  await db.doc('adminAccess/ordinary').set({role: 'user'});
});
integration('missing profiles produce explicit not-found instead of incomplete creation', async () => {
  await assert.rejects(() => api.adminUpdateProfile.run(request('admin', {uid: 'manager', profile: {
    language: 'nl', themeMode: 'system', profileComplete: false}})), e => e.code === 'not-found');
});
