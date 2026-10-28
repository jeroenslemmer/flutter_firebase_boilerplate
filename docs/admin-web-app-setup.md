# Beheerwebapp installeren en testen

De aparte website staat in `admin-web/`, de callable Firebase-backend in
`functions/`. De website gebruikt HTML/CSS/JavaScript en de modulaire Firebase
Web SDK via de officiële CDN. Er is geen Flutter-build nodig voor beheer.
De gebruikersapp blijft Flutter. Deployments zijn bewust gescheiden.

## Rollen en gegevens

| Rol | Rechten |
| --- | --- |
| `admin` | Alle accounts/profielen bekijken, profielen aanpassen, andere accounts een rol geven |
| `user-manager` | Alleen gewone users bekijken, profielen aanpassen en blokkeren/deblokkeren |
| `user` | Eigen profiel beheren in de bestaande gebruikersapp; geen toegang tot beheer |

De interface noemt `user-manager` **Gebruikersbeheerder**. Een ontbrekende
rolregistratie betekent `user`; bestaande gebruikers hoeven niet gemigreerd.
Ook een admin beheert het eigen profiel. Eigen rol wijzigen of zichzelf
blokkeren is niet toegestaan. Bevoorrechte accounts moeten eerst door een
andere admin naar `user` worden teruggezet voordat blokkeren mogelijk is.
De laatste admin wordt bij rolwijzigingen beschermd.

- Authentication bevat e-mail, providers, verificatie en blokkering.
- `users/{uid}` blijft het appprofiel. Beheer kan uitsluitend `language`
  (`nl`, `en`, `fr`), `themeMode` (`system`, `light`, `dark`) en de boolean
  `profileComplete` aanpassen. UID, aanmaakdatum en laatste login zijn alleen-lezen.
- Ontbrekende appprofielen worden getoond, niet automatisch aangemaakt; de
  gebruikersapp maakt ze bij aanmelden aan.
- `adminAccess/{uid}` bevat de gezaghebbende beheerrol. Alleen de backend en
  bevoegde operators kunnen deze collectie benaderen. Rollen staan **niet** in
  het door de gebruiker bewerkbare profiel.
- De backend spiegelt de rol naar de custom claim `role`. Deze claim alleen is
  geen toegangsbewijs voor beheer: iedere aanvraag leest de actuele registratie.
  Daardoor is intrekken effectief bij de eerstvolgende backendaanvraag, ook
  met een ouder token. Reeds getoonde gegevens verdwijnen niet automatisch uit
  een open browservenster; uitloggen wist de weergegeven details.
- `adminAudit` registreert profiel-, rol- en blokkeerwijzigingen. Profiel/rol en
  logboek worden atomair opgeslagen. Er is nog geen logboekscherm; bevoegde
  projectoperators bekijken dit via Firestore Console.

De browser krijgt geen directe beheerrechten op Firestore. De bestaande
owner-only regels blijven gelden. De enige wijziging aan het profielcontract
is het toestaan van `fr`, in overeenstemming met de bestaande taalkeuze.

## Lokaal installeren

Gebruik Node.js 22 voor de backend, Java 21+ voor de Firestore-emulator en een
actuele Firebase CLI. De backend is tevens lokaal getest onder Node 20.20.2;
Firebase Functions gebruikt bij deployment de opgegeven Node 22-runtime.

```sh
npm ci --prefix functions
npm ci --prefix firebase-tests
```

Pure beleidsregels en emulatorintegratietests:

```sh
firebase-tests/node_modules/.bin/firebase emulators:exec --config firebase.admin.json --project demo-flutter-firebase-boilerplate --only auth,firestore 'node --test functions/test/*.test.js'
npm test --prefix firebase-tests
flutter analyze
flutter test
```

Voer emulatorcommando's na elkaar uit: ze gebruiken dezelfde poort 8080.
`npm test --prefix functions` zonder emulators draait alleen de pure tests;
het integratiedeel wordt dan expliciet overgeslagen.
De integratietests roepen de echte handlers aan met gesimuleerde callable-auth
context en gebruiken echte lokale Auth-/Firestore-emulators. De browsertest
controleert aanvullend het callable HTTP-transport en de SDK-aanmelding.

## Lokale browserflow met uitsluitend demo-accounts

Terminal 1:

```sh
firebase-tests/node_modules/.bin/firebase emulators:start --config firebase.admin.json --project demo-flutter-firebase-boilerplate --only auth,firestore,functions
```

Terminal 2, eenmalig testaccounts en profielen aanmaken:

```sh
GCLOUD_PROJECT=demo-flutter-firebase-boilerplate FIRESTORE_EMULATOR_HOST=127.0.0.1:8080 FIREBASE_AUTH_EMULATOR_HOST=127.0.0.1:9099 node --test functions/test/integration.test.js
python3 -m http.server 8787 --bind 127.0.0.1 --directory admin-web
```

Open `http://127.0.0.1:8787/?emulator=1`. Alleen op loopback schakelt deze parameter
alle backenddiensten naar het demo-project. Gebruik de tijdelijke lokale
accounts `admin@example.com`, `manager@example.com` of `ordinary@example.com`
met wachtwoord `Test-password-42!`. Dit zijn uitsluitend emulatorfixtures;
maak deze accounts niet in productie aan. Testdata verdwijnt na emulatorstop.
Zonder `?emulator=1` gebruikt de website de configuratie in `config.js`.

## Productie instellen en publiceren

1. Kies het Firebase-project van de afgeleide app en vervang de openbare
   Firebase-configuratie in `admin-web/config.js`. Deze is geen beheergeheim.
2. Cloud Functions vereist een geschikte billingconfiguratie (Blaze). Controleer
   de gekozen regio `europe-west1`; wijzig die zowel in backend als frontend als
   een andere regio nodig is. Bespreek kosten voordat je billing inschakelt.
3. Gebruik persoonlijke, actieve accounts met geverifieerd e-mailadres.
   Maak het eerste account via de gebruikersapp aan. Google-accounts werken
   met de backend, maar de eerste beheerwebsite biedt alleen e-mail/wachtwoordlogin;
   gebruik daarvoor een account met die provider.
4. Stel Application Default Credentials in voor een bevoegde operator, bijvoorbeeld
   met `gcloud auth application-default login`. Bewaar geen serviceaccountkey in
   de repository. Wijs expliciet het eerste persoonlijke adminaccount toe:

   ```sh
   npm run bootstrap --prefix functions -- PROJECT_ID UID
   ```

   Dit script schrijft de rol en het logboek en synchroniseert de custom claim.
   Het kan ook worden gebruikt om na een mislukte claimsynchronisatie een
   **admin** opnieuw te synchroniseren. Gebruik het niet om een user-manager te
   synchroniseren: het kent altijd admin toe.
5. Deploy regels en backend expliciet naar het juiste project:

   ```sh
   firebase deploy --project PROJECT_ID --config firebase.admin.json --only firestore:rules,functions:admin
   ```

6. Maak een **aparte Firebase Hosting-site** voor beheer, kies zelf een beschikbare
   site-ID en verbind die met target `admin`:

   ```sh
   firebase hosting:sites:create ADMIN_SITE_ID --project PROJECT_ID
   firebase target:apply hosting admin ADMIN_SITE_ID --project PROJECT_ID
   firebase deploy --project PROJECT_ID --config firebase.admin.json --only hosting:admin
   ```

   Bewaar de targetmapping in `.firebaserc` van de afgeleide app. Gebruik geen
   bestaande gebruikersapp-site als beheer-target: die zou worden overschreven.
7. Voeg het beheerdomein toe bij Authentication → Settings → Authorized domains.
   Test daarna aanmelding, herstelmail en toegangsweigering met echte accounts.
   De Action URL-aanvraag bij Support blijft afzonderlijk nodig voor de bestaande
   eigen e-mailhandler. Deze implementatie verandert geen e-mailinstellingen.

Er zijn tijdens implementatie geen productieaccounts, rollen, billinginstellingen,
Hosting-sites of Firestore-regels op afstand gewijzigd.

## Gedeeltelijk geslaagde accountacties herstellen

Auth en Firestore delen geen transactie. De backend legt vóór blokkeren een
`pending` auditrecord vast en vergrendelt het doelaccount via `statusPending`.
Na succesvolle Auth-wijziging en tokenintrekking wordt de status `completed`.
Bij een fout meldt de interface nadrukkelijk geen succes. Rollen wijzigen en
herhaalde blokkeeracties blijven geblokkeerd zolang `statusPending` bestaat.

Een bevoegde projectoperator controleert bij een pending actie eerst de actuele
Auth-accountstatus en voert zo nodig opnieuw tokenintrekking uit via de Admin SDK.
Pas na verificatie markeert de operator het auditrecord als afgehandeld en
verwijdert `statusPending` uit `adminAccess/{uid}`. Verwijder deze vergrendeling
niet blind: de eerdere Auth-aanroep kan wel uitgevoerd zijn.

Blokkeren voorkomt nieuwe logins en trekt refresh tokens in. Bestaande ID-tokens
kunnen nog tot ongeveer een uur geldig zijn bij diensten die geen actuele
blokkeerstatus controleren, waaronder de huidige eigenaarregels voor profielen.
Beheerendpoints controleren de actuele Auth-status wel bij iedere aanvraag.

## Handmatige acceptatie per platform

De beheerinterface is Nederlandstalig en responsive. Er zijn geen aparte native
beheerapps voor macOS, iOS of Android; op die platformen gebruik je de browser.
Profieltalen NL/EN/FR worden in de gebruikersapp ondersteund.

Voer op web/desktop (macOS), Safari op iOS en Chrome op Android uit:

- Aanmelden als user wordt geweigerd; admin en gebruikersbeheerder krijgen hun scope.
- Zoek een exact e-mailadres en UID, test geen resultaat en paginering.
- Open een gebruiker, wijzig taal/thema/profielstatus en laad opnieuw.
- Controleer de aangepaste velden na herladen/aanmelden in de Flutter-gebruikersapp
  op web, macOS, iOS en Android. Een build of backendtest bewijst dit niet.
- Een gebruikersbeheerder kan geen bevoorrecht account opvragen of rol wijzigen.
- Een admin kan een andere gebruiker een rol geven en die weer intrekken.
- Blokkeren/deblokkeren werkt met bevestiging en een auditrecord.
- Controleer kleine schermen, toetsenbordfocus en netwerkmeldingen.
- Controleer dat profieldata na uitloggen uit de interface verdwijnt.

Zie de voortgang in het ontwerpdocument voor de daadwerkelijk uitgevoerde checks.


## Alternatief: website hosten bij Strato

De statische website kan ook op eigen webspace staan, terwijl Authentication,
Firestore en Cloud Functions in Firebase blijven. Gebruik het
[Strato-uploadpakket en stappenplan](admin-strato-install.md). Deploy in dat
geval alleen Firebase-regels en functions; een Firebase Hosting-site is niet nodig.


## Testpakket voor een tweede Windows-pc

Gebruik [het Windows-testpakket](admin-windows-test.md) voor een lokale demo
zonder productieconfiguratie, met een startbestand, tijdelijke demo-accounts
en lokale Auth-/Firestore-/Functions-emulators. Python en Flutter zijn op de
Windows-testmachine niet nodig.
