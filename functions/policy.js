export const roles = ['admin', 'user-manager', 'user'];
export function roleOf(snapshot) {
  const role = snapshot?.data()?.role;
  return roles.includes(role) ? role : 'user';
}
export function canManage(actorRole, targetRole) {
  return actorRole === 'admin' || (actorRole === 'user-manager' && targetRole === 'user');
}
export function profilePatch(input) {
  if (!input || typeof input !== 'object' || Array.isArray(input) ||
      Object.keys(input).sort().join(',') !== 'language,profileComplete,themeMode' ||
      !['nl', 'en', 'fr'].includes(input.language) ||
      !['system', 'light', 'dark'].includes(input.themeMode) ||
      typeof input.profileComplete !== 'boolean') throw new Error('invalid-profile');
  return {language: input.language, themeMode: input.themeMode, profileComplete: input.profileComplete};
}
