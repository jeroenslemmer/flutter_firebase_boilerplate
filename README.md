# flutter_firebase_boilerplate

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Roadmap

### Fase 1
- [x] Firebase Authentication met verificatie, herstel en accountverwijdering
- [x] Firestore user profile
- [x] Email/password login
- [x] Google Sign-In (web)
- [x] Google Sign-In (iOS)
- [ ] Google Sign-In (Android: OAuth-configuratie aanwezig; apparaatacceptatie nog nodig)
- [x] Apple Sign-In (iOS; configuratie per afgeleide app vereist)

### Fase 2
- [ ] Settings
- [ ] Meertaligheid
- [ ] Theme support
- [ ] Offline caching

### Fase 3
- [ ] Push notifications
- [ ] Crash reporting
- [ ] Analytics

## Test
- web app (local): flutter run -d chrome --web-hostname localhost --web-port 7357
- Flutter: `flutter test`
- Firestore Security Rules: `cd firebase-tests && npm install && npm test`

Voor de Firestore-tests zijn Node.js 20+ en JDK 21+ nodig. De tests draaien
uitsluitend tegen een lokale `demo-*` Firebase-emulator.

Lees voor iedere app die van deze boilerplate wordt afgeleid eerst het
[Firestore-protocol](docs/firestore-derived-app-protocol.md).

Volg daarnaast de
[authenticatie-instructies](docs/authentication-setup.md) voor de Firebase-,
Google- en Apple-configuratie van iedere afgeleide app.

Vertalingen worden via aparte Git-branches aangeleverd. Zie de
[Git-workflow voor vertalingen](docs/translation-workflow.md). Controleer een
wijziging met `dart run tool/check_translations.dart`.

Start de lokale vertaaleditor in VS Code via **Terminal → Run Task →
Translations: Edit English**.

## Release
- web app (host): flutter build web --releasename: flutter_firebase_boilerplate

Authenticatiemails gebruiken de browserhandler `/auth/action` op web, macOS,
iOS en Android. Zie [configuratie en acceptatietests](docs/authentication-setup.md#6-gedeelde-action-url), inclusief de vereiste Firebase Support-wijziging.
