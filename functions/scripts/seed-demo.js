// Disposable emulator data only. Refuses production and non-loopback endpoints.
import {initializeApp} from 'firebase-admin/app';
import {getAuth} from 'firebase-admin/auth';
import {getFirestore, Timestamp} from 'firebase-admin/firestore';
const projectId = 'demo-flutter-firebase-boilerplate';
if (process.env.GCLOUD_PROJECT !== projectId ||
    process.env.FIREBASE_AUTH_EMULATOR_HOST !== '127.0.0.1:9099' ||
    process.env.FIRESTORE_EMULATOR_HOST !== '127.0.0.1:8080') {
  throw new Error('Demo seed requires the exact local demo project and emulator addresses.');
}
initializeApp({projectId});
const auth = getAuth(), db = getFirestore();
for (const [uid, role] of [['admin', 'admin'], ['manager', 'user-manager'], ['ordinary', 'user']]) {
  const record = {email: `${uid}@example.com`, password: 'Test-password-42!', emailVerified: true, disabled: false};
  try {await auth.createUser({uid, ...record});}
  catch (error) {if (error.code !== 'auth/uid-already-exists') throw error; await auth.updateUser(uid, record);}
  await auth.setCustomUserClaims(uid, {role});
  await db.doc(`adminAccess/${uid}`).set({role});
  await db.doc(`users/${uid}`).set({language: 'nl', themeMode: 'system', profileComplete: false,
    createdAt: Timestamp.now(), lastLogin: Timestamp.now()});
}
console.log('Drie lokale demo-accounts en Firestore-profielen zijn gereed.');
