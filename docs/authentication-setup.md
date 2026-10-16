# Authenticatie instellen voor een afgeleide app

Deze boilerplate bevat e-mail/wachtwoord, Google-login, Apple-login,
e-mailverificatie, wachtwoordherstel en accountverwijdering. De code is
generiek, maar iedere afgeleide app heeft eigen Firebase- en Apple-instellingen
nodig.

## 1. Firebase-project

1. Maak of selecteer het Firebase-project van de afgeleide app.
2. Registreer de Android-, iOS-, macOS- en web-apps met hun definitieve
   bundle- en package-identifiers.
3. Genereer de FlutterFire-configuratie opnieuw:

   ```sh
   flutterfire configure
   ```

4. Activeer in **Firebase Console → Authentication → Sign-in method**:
   - Email/Password
   - Google
   - Apple voor apps die op iOS/macOS worden uitgebracht
5. Controleer onder **Settings → Authorized domains** alle webdomeinen.
6. Pas onder **Templates** de afzender, verificatiemail en resetmail aan op de
   naam en huisstijl van de afgeleide app.

Gebruik nooit Firebase-configuratie of OAuth-client-id's van de boilerplate in
een productie-app.

## 2. Google-login

- Android: registreer de debug- en release-SHA-certificaten in Firebase.
- iOS/macOS: controleer URL schemes en het gegenereerde
  `GoogleService-Info.plist`.
- Web: vervang de Google web client-id in `lib/core/firebase/auth_service.dart`
  door die van de afgeleide app. Maak dit bij verdere productisering bij
  voorkeur onderdeel van de buildconfiguratie.

## 3. Apple-login

1. Activeer **Sign in with Apple** voor de App ID in Apple Developer.
2. Activeer Apple als provider in Firebase Authentication en vul zo nodig de
   Service ID, Team ID, Key ID en private key in.
3. Open `ios/Runner.xcworkspace` en controleer bij **Signing & Capabilities** dat
   Sign in with Apple gekoppeld is aan het juiste team en bundle-id.
4. Herhaal dit voor macOS wanneer die variant wordt uitgebracht.

De entitlement-bestanden staan al in het project; Apple Developer en Firebase
moeten nog per afgeleide app worden gekoppeld.

## 4. Firestore en accountverwijdering

Bij iedere succesvolle login maakt de app zo nodig `users/{uid}` aan. Bij
accountverwijdering wordt eerst opnieuw geauthenticeerd, daarna het
Firestore-profiel verwijderd en ten slotte het Firebase Auth-account.

Breidt een afgeleide app gebruikersdata uit naar subcollecties, uploads of
andere collecties, voer de totale verwijdering dan uit via een beveiligde
backend/Cloud Function. Een mobiele client kan geen betrouwbare recursieve
verwijdering garanderen. Volg daarnaast
`docs/firestore-derived-app-protocol.md` voor opslag en rules.

## 5. Acceptatietest

- Registreer een e-mailaccount en controleer dat de verificatiemail aankomt.
- Controleer dat toegang geblokkeerd blijft tot het adres geverifieerd is.
- Test opnieuw verzenden en wachtwoordherstel in Nederlands en Engels.
- Test Google-login op alle ondersteunde platforms.
- Test Apple-login op een echt Apple-apparaat met de productie-identifiers.
- Controleer dat `users/{uid}` na iedere login bestaat.
- Verwijder elk accounttype en controleer Firebase Auth én Firestore.
- Draai `flutter analyze`, `flutter test` en de Firestore Rules-tests.
