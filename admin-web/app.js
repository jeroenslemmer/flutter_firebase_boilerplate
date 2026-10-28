import {initializeApp} from 'https://www.gstatic.com/firebasejs/13.1.0/firebase-app.js';
import {getAuth, onAuthStateChanged, signInWithEmailAndPassword, signOut, sendPasswordResetEmail, setPersistence, browserSessionPersistence} from 'https://www.gstatic.com/firebasejs/13.1.0/firebase-auth.js';
import {getFunctions, httpsCallable, connectFunctionsEmulator} from 'https://www.gstatic.com/firebasejs/13.1.0/firebase-functions.js';
import {connectAuthEmulator} from 'https://www.gstatic.com/firebasejs/13.1.0/firebase-auth.js';
import {firebaseConfig, region} from './config.js';
const useEmulators = ['localhost', '127.0.0.1'].includes(location.hostname) && new URLSearchParams(location.search).get('emulator') === '1';
const app = initializeApp(useEmulators ? {...firebaseConfig, projectId: 'demo-flutter-firebase-boilerplate', apiKey: 'demo-api-key'} : firebaseConfig);
const auth = getAuth(app), functions = getFunctions(app, region);
// Emulators are opt-in and restricted to loopback. Never enabled on deployed hosts.
if (useEmulators) {
  connectAuthEmulator(auth, 'http://127.0.0.1:9099');
  connectFunctionsEmulator(functions, '127.0.0.1', 5001);
}
await setPersistence(auth, browserSessionPersistence);
const $ = id => document.getElementById(id);
const names = {admin: 'Admin', 'user-manager': 'Gebruikersbeheerder', user: 'User'};
let session, token, selected, generation = 0, busy = false;
function message(text = '', error = false) { $('message').textContent = text; $('message').classList.toggle('error', error); }
function element(tag, text, cls) {const el = document.createElement(tag); if (text !== undefined) el.textContent = text; if (cls) el.className = cls; return el;}
function button(text, action, cls = 'secondary') {const el = element('button', text, cls); el.type = 'button'; el.onclick = () => run(action); return el;}
async function call(name, data = {}) { return (await httpsCallable(functions, name)(data)).data; }
function errorText(error) {
  if (error.code?.startsWith('auth/')) return 'Inloggen of versturen is niet gelukt. Controleer je gegevens en probeer opnieuw.';
  return error.message || 'Er ging iets mis. Probeer opnieuw.';
}
async function run(action) {
  if (busy) return;
  busy = true; message();
  document.querySelectorAll('button').forEach(b => b.disabled = true);
  try {await action();} catch (error) {message(errorText(error), true);}
  finally {busy = false; document.querySelectorAll('button').forEach(b => b.disabled = false);}
}
function clearDetail() {selected = null; $('detail').replaceChildren(element('h2', 'Accountdetails'), element('p', 'Selecteer een gebruiker om het account en Firestore-profiel te bekijken.', 'muted'));}
async function list(pageToken) {
  const version = generation;
  const data = await call('adminListUsers', {search: $('search').value.trim(), ...(pageToken ? {pageToken} : {})});
  if (version !== generation) return;
  clearDetail(); token = data.nextPageToken; $('next').hidden = !token;
  $('count').textContent = `${data.users.length} op deze pagina`;
  $('users').replaceChildren();
  if (!data.users.length) $('users').append(element('p', 'Geen toegankelijke gebruikers op deze pagina. Gebruik eventueel de volgende pagina of zoek op e-mailadres.', 'muted'));
  for (const user of data.users) {
    const row = button('', async () => {await detail(user.uid); document.querySelectorAll('.user-row').forEach(r => r.classList.remove('active')); row.classList.add('active');}, 'user-row');
    const info = element('span'); info.append(element('strong', user.email || 'Zonder e-mailadres'), element('small', `${names[user.role]} · ${user.providers.join(', ') || 'Geen provider'}`));
    row.append(info, element('span', user.disabled ? 'Geblokkeerd' : 'Actief', `status ${user.disabled ? 'blocked' : ''}`)); $('users').append(row);
  }
}
function addField(list, name, value) {list.append(element('dt', name), element('dd', value || '—'));}
function select(label, options, value) {
  const wrap = element('label', label), input = element('select');
  for (const [key, text] of options) {const option = element('option', text); option.value = key; input.append(option);}
  input.value = value; wrap.append(input); return {wrap, input};
}
async function detail(uid) {
  const version = generation, data = await call('adminGetUser', {uid});
  if (version !== generation) return;
  selected = uid; const {user, profile} = data, panel = $('detail');
  panel.replaceChildren(element('h2', user.email || 'Account zonder e-mailadres'));
  const facts = element('dl');
  addField(facts, 'UID', uid); addField(facts, 'Rol', names[user.role]);
  addField(facts, 'E-mailadres', user.emailVerified ? 'Geverifieerd' : 'Niet geverifieerd');
  addField(facts, 'Status', user.disabled ? 'Geblokkeerd' : 'Actief');
  addField(facts, 'Inlogmethode', user.providers.join(', '));
  addField(facts, 'Aangemaakt', user.createdAt); addField(facts, 'Laatste login', user.lastSignIn);
  panel.append(facts, element('hr'), element('h2', 'Firestore-profiel'));
  if (profile) {
    const form = element('form');
    const language = select('Taal', [['nl', 'Nederlands'], ['en', 'English'], ['fr', 'Français']], profile.language);
    const theme = select('Thema', [['system', 'Systeem'], ['light', 'Licht'], ['dark', 'Donker']], profile.themeMode);
    const check = element('label', undefined, 'check'), complete = element('input'); complete.type = 'checkbox'; complete.checked = profile.profileComplete;
    check.append(complete, document.createTextNode('Profiel compleet'));
    const save = element('button', 'Profiel opslaan');
    form.append(language.wrap, theme.wrap, check, save);
    form.onsubmit = event => {event.preventDefault(); run(async () => {
      await call('adminUpdateProfile', {uid, profile: {language: language.input.value, themeMode: theme.input.value, profileComplete: complete.checked}});
      await detail(uid); message('Firestore-profiel opgeslagen.');
    });}; panel.append(form);
    const dates = element('dl'); addField(dates, 'Profiel gemaakt', profile.createdAt); addField(dates, 'App-login', profile.lastLogin); panel.append(dates);
  } else panel.append(element('p', 'Dit account heeft nog geen Firestore-profiel. Het profiel wordt aangemaakt bij aanmelden in de gebruikersapp.', 'muted'));
  if (session.role === 'admin' && uid !== auth.currentUser.uid) {
    panel.append(element('hr'), element('h2', 'Beheerrechten'));
    const role = select('Rol', Object.entries(names), user.role);
    panel.append(role.wrap, button('Rol wijzigen', async () => {
      if (!confirm(`Rol van ${user.email || uid} wijzigen naar ${names[role.input.value]}?`)) return;
      const result = await call('adminSetRole', {uid, role: role.input.value});
      await list(); await detail(uid);
      message(result.claimsSynced ? 'Rol gewijzigd. Rechten gelden direct bij de volgende beheeractie.' : 'Rol gewijzigd, maar de tokenclaim is nog niet bijgewerkt. De backend gebruikt de nieuwe rol; synchroniseer de claim via het beheerdersscript.');
    }));
  }
  if (uid !== auth.currentUser.uid && user.role === 'user') {
    panel.append(element('hr'), element('h2', 'Accounttoegang'), element('p', 'Blokkeren verhindert nieuwe aanmeldingen. Bestaande toegangstokens kunnen tot ongeveer een uur geldig blijven.', 'muted'));
    panel.append(button(user.disabled ? 'Account deblokkeren' : 'Account blokkeren', async () => {
      if (!confirm(`${user.email || uid} ${user.disabled ? 'deblokkeren' : 'blokkeren'}?`)) return;
      await call('adminSetDisabled', {uid, disabled: !user.disabled}); await list(); await detail(uid); message('Accountstatus bijgewerkt.');
    }, 'danger'));
  }
}
$('login-form').onsubmit = event => {event.preventDefault(); const form = new FormData(event.target); run(async () => {
  await signInWithEmailAndPassword(auth, form.get('email').trim(), form.get('password')); event.target.reset();
});};
$('reset').onclick = () => run(async () => {
  const email = $('login-form').elements.email.value.trim();
  if (!email) {message('Vul eerst je e-mailadres in.', true); return;}
  await sendPasswordResetEmail(auth, email); message('Als dit account bestaat, ontvang je een herstelmail.');
});
$('search-form').onsubmit = event => {event.preventDefault(); run(() => list());};
$('clear').onclick = () => run(async () => {$('search').value = ''; await list();});
$('next').onclick = () => run(() => list(token));
onAuthStateChanged(auth, async user => {
  const version = ++generation; session = null; selected = null; token = null;
  $('workspace').hidden = true; $('login').hidden = !!user; $('users').replaceChildren(); $('identity').replaceChildren(); clearDetail();
  if (!user) {message(); return;}
  $('identity').append(element('span', user.email), button('Uitloggen', () => signOut(auth)));
  try {
    const result = await call('adminSession'); if (version !== generation) return;
    session = result; $('role-label').textContent = names[session.role]; $('workspace').hidden = false;
    await list();
  } catch (error) {if (version === generation) message(errorText(error), true);}
});
