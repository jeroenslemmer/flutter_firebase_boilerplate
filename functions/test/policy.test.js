import assert from 'node:assert/strict';
import {test} from 'node:test';
import {canManage, profilePatch} from '../policy.js';
test('manager may only manage ordinary users; admin may manage all roles', () => {
  for (const target of ['admin', 'user-manager', 'user']) {
    assert.equal(canManage('admin', target), true);
    assert.equal(canManage('user-manager', target), target === 'user');
    assert.equal(canManage('user', target), false);
  }
});
test('profile edits cannot inject roles or timestamps', () => {
  const profile = {language: 'fr', themeMode: 'dark', profileComplete: true};
  assert.deepEqual(profilePatch(profile), profile);
  for (const extra of [{role: 'admin'}, {createdAt: 0}, {lastLogin: 0}]) {
    assert.throws(() => profilePatch({...profile, ...extra}));
  }
  for (const invalid of [{language: 'de'}, {themeMode: 'sepia'}, {profileComplete: 'true'}]) {
    assert.throws(() => profilePatch({...profile, ...invalid}));
  }
});
