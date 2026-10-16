import assert from 'node:assert/strict';
import { after, before, beforeEach, test } from 'node:test';
import { readFile } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';
import path from 'node:path';

import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from '@firebase/rules-unit-testing';
import {
  Timestamp,
  collection,
  deleteDoc,
  doc,
  getDoc,
  getDocs,
  serverTimestamp,
  setDoc,
  updateDoc,
} from 'firebase/firestore';

const testDirectory = path.dirname(fileURLToPath(import.meta.url));
const projectRoot = path.resolve(testDirectory, '..');
const projectId = 'demo-flutter-firebase-boilerplate';

let testEnvironment;

function validProfile(overrides = {}) {
  return {
    createdAt: serverTimestamp(),
    lastLogin: serverTimestamp(),
    profileComplete: false,
    language: 'nl',
    themeMode: 'system',
    ...overrides,
  };
}

async function seedProfile(userId, overrides = {}) {
  await testEnvironment.withSecurityRulesDisabled(async (context) => {
    await setDoc(doc(context.firestore(), 'users', userId), {
      createdAt: Timestamp.fromMillis(1_700_000_000_000),
      lastLogin: Timestamp.fromMillis(1_700_000_000_000),
      profileComplete: false,
      language: 'nl',
      themeMode: 'system',
      ...overrides,
    });
  });
}

before(async () => {
  const rules = await readFile(
    path.join(projectRoot, 'firestore.rules'),
    'utf8',
  );

  testEnvironment = await initializeTestEnvironment({
    projectId,
    firestore: { rules },
  });
});

beforeEach(async () => {
  await testEnvironment.clearFirestore();
});

after(async () => {
  await testEnvironment.cleanup();
});

test('an unauthenticated client cannot read a user profile', async () => {
  await seedProfile('alice');
  const db = testEnvironment.unauthenticatedContext().firestore();

  await assertFails(getDoc(doc(db, 'users', 'alice')));
});

test('a user can read their own profile', async () => {
  await seedProfile('alice');
  const db = testEnvironment.authenticatedContext('alice').firestore();

  await assertSucceeds(getDoc(doc(db, 'users', 'alice')));
});

test('a user cannot read another user profile', async () => {
  await seedProfile('bob');
  const db = testEnvironment.authenticatedContext('alice').firestore();

  await assertFails(getDoc(doc(db, 'users', 'bob')));
});

test('a user cannot list the users collection', async () => {
  await seedProfile('alice');
  const db = testEnvironment.authenticatedContext('alice').firestore();

  await assertFails(getDocs(collection(db, 'users')));
});

test('a user can create their own valid profile', async () => {
  const db = testEnvironment.authenticatedContext('alice').firestore();

  await assertSucceeds(setDoc(doc(db, 'users', 'alice'), validProfile()));
});

test('a user cannot create another user profile', async () => {
  const db = testEnvironment.authenticatedContext('alice').firestore();

  await assertFails(setDoc(doc(db, 'users', 'bob'), validProfile()));
});

test('a profile rejects unsupported language and theme values', async () => {
  const db = testEnvironment.authenticatedContext('alice').firestore();

  await assertFails(
    setDoc(doc(db, 'users', 'alice'), validProfile({ language: 'de' })),
  );
  await assertFails(
    setDoc(doc(db, 'users', 'alice'), validProfile({ themeMode: 'sepia' })),
  );
});

test('a profile rejects missing, extra, and incorrectly typed fields', async () => {
  const db = testEnvironment.authenticatedContext('alice').firestore();
  const missingField = validProfile();
  delete missingField.profileComplete;

  await assertFails(setDoc(doc(db, 'users', 'alice'), missingField));
  await assertFails(
    setDoc(doc(db, 'users', 'alice'), validProfile({ isAdmin: true })),
  );
  await assertFails(
    setDoc(
      doc(db, 'users', 'alice'),
      validProfile({ profileComplete: 'yes' }),
    ),
  );
});

test('a user can update allowed fields on their own profile', async () => {
  await seedProfile('alice');
  const db = testEnvironment.authenticatedContext('alice').firestore();

  await assertSucceeds(
    updateDoc(doc(db, 'users', 'alice'), {
      language: 'en',
      themeMode: 'dark',
      profileComplete: true,
    }),
  );
  await assertSucceeds(
    updateDoc(doc(db, 'users', 'alice'), { lastLogin: serverTimestamp() }),
  );
});

test('a user cannot change createdAt or forge lastLogin', async () => {
  await seedProfile('alice');
  const db = testEnvironment.authenticatedContext('alice').firestore();

  await assertFails(
    updateDoc(doc(db, 'users', 'alice'), {
      createdAt: Timestamp.fromMillis(1_800_000_000_000),
    }),
  );
  await assertFails(
    updateDoc(doc(db, 'users', 'alice'), {
      lastLogin: Timestamp.fromMillis(1_800_000_000_000),
    }),
  );
});

test('a user cannot update another user profile', async () => {
  await seedProfile('bob');
  const db = testEnvironment.authenticatedContext('alice').firestore();

  await assertFails(
    updateDoc(doc(db, 'users', 'bob'), { language: 'en' }),
  );
});

test('only the owner can delete a user profile', async () => {
  await seedProfile('alice');
  const aliceDb = testEnvironment.authenticatedContext('alice').firestore();
  const bobDb = testEnvironment.authenticatedContext('bob').firestore();

  await assertFails(deleteDoc(doc(bobDb, 'users', 'alice')));
  await assertSucceeds(deleteDoc(doc(aliceDb, 'users', 'alice')));
});

test('undeclared collections are inaccessible', async () => {
  const db = testEnvironment.authenticatedContext('alice').firestore();

  await assertFails(setDoc(doc(db, 'private', 'document'), { value: true }));
});
