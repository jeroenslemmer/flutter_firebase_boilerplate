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
   - Apple voor apps die op iOS worden uitgebracht
5. Controleer onder **Settings → Authorized domains** alle webdomeinen.
6. Pas onder **Templates** de afzender, verificatiemail en resetmail aan op de
   naam en huisstijl van de afgeleide app.

Gebruik nooit Firebase-configuratie of OAuth-client-id's van de boilerplate in
een productie-app.

## 2. Google-login

- Android: registreer de debug- en release-SHA-certificaten in Firebase.
  Download daarna opnieuw `google-services.json` naar `android/app/`.
  Controleer dat de Android OAuth-client bij de package-id en het gebruikte
  SHA-1-certificaat hoort en dat ook een web OAuth-client (`client_type: 3`)
  aanwezig is. `AuthService` gebruikt deze web client-id als `serverClientId`
  om een Firebase ID-token te verkrijgen. Gebruik hier geen Android client-id.
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
De iOS-entitlement staat al in het project; Apple Developer en Firebase
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
- Test Google-login op web, macOS, iOS en Android. Test Android zowel met
  de debughandtekening als met de release-/Play App Signing-handtekening.
  Controleer na Google-login dat Firebase Auth een gebruiker heeft en dat het
  profiel geladen wordt. Een geslaagde build bewijst de OAuth-configuratie niet.
- Test Apple-login op een echt Apple-apparaat met de productie-identifiers.
- Controleer dat `users/{uid}` na iedere login bestaat.
- Verwijder elk accounttype en controleer Firebase Auth én Firestore.
- Draai `flutter analyze`, `flutter test` en de Firestore Rules-tests.

## 6. Gedeelde Action URL

De browserhandler `/auth/action` ondersteunt `resetPassword`, `verifyEmail`,
`recoverEmail` en `verifyAndChangeEmail`. Onbekende modes en ontbrekende codes
worden afgewezen. E-maillink-login (`signIn`) is niet geïmplementeerd.
De app biedt zelf geen functie om een e-mailadres te wijzigen.

Op web, macOS, iOS en Android opent de e-mailactie in de browser; native
app-links zijn niet nodig. Na verificatie keer je terug naar de app en kies je
**Ik heb mijn e-mailadres bevestigd**, of log je opnieuw in. De Firebase-
configuratie komt uit de app; `apiKey` uit de URL wordt niet gebruikt.
Een eventuele `continueUrl` wordt niet automatisch geopend.

Ingebruikname voor dit project:

1. Bouw met `flutter build web` en deploy met `firebase deploy --only hosting`.
2. Controleer `https://base-app-f5a6e.web.app/auth/action` en controleer dat
   `base-app-f5a6e.web.app` onder Authorized domains staat.
3. Vraag bij `EMAIL_TEMPLATE_UPDATE_NOT_ALLOWED` Firebase Support om de gedeelde
   Action URL te wijzigen. Geef de huidige URL uit de Console, de exacte gewenste
   URL, bevestiging van bereikbaarheid en Authorized domains, en expliciete
   toestemming voor review en toepassing. Vraag de mailinhoud te behouden.
   Bevestig bereikbaarheid en instellingen pas na controle.
4. Test met nieuwe echte mails na de wijziging; oude mails kunnen de oude URL
   bevatten. Een build bewijst de Firebase-instellingen niet.

Handmatige acceptatie, afzonderlijk op web, macOS, iOS en Android:

- Registreer een account, open de verificatiemail en controleer daarna de
  verificatiestatus in de oorspronkelijke app. Test een uitgelogde browser.
- Vraag wachtwoordherstel aan, stel via de mail een nieuw wachtwoord in en
  log daarmee in op het oorspronkelijke platform.
- Test gebruikte, verlopen en beschadigde links: duidelijke foutmelding en
  instructie om een nieuwe mail aan te vragen.
- Test NL, EN en FR, ingelogde en uitgelogde browsers en onbekende modes.
- Indien adreswijziging elders gebruikt wordt: test `verifyAndChangeEmail` en
  `recoverEmail` met echte Firebase-mails.

Vervang domein en Firebase-project voor iedere afgeleide app.

### Verificatiestatus 27 oktober 2026

- `flutter analyze`: geslaagd; `flutter test`: 13 tests geslaagd.
- Webrelease en Android debug-APK: gebouwd.
- iOS: simulator-debugbuild gebouwd; geen fysieke-apparaattest uitgevoerd.
- Firebase Hosting: handler gedeployed. In de browser zijn ontbrekende en
  ongeldige verificatiecodes getest, inclusief `lang=en`.
- macOS: build zonder ondertekening geslaagd. De normale debugbuild blokkeert
  op een ontbrekend provisioningprofiel; ondertekend draaien is niet getest.
- Echte e-mailacties op de vier platforms moeten nog worden getest na de
  gedeelde Action URL-wijziging door Support. Authorized domains is live
  gecontroleerd: `base-app-f5a6e.web.app` staat in de lijst. De huidige Action
  URL is `https://base-app-f5a6e.firebaseapp.com/__/auth/action`.
  Zie `firebase-support-action-url.md` voor het ingevulde antwoord.
