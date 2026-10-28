# Beheerwebsite op een Strato-subdomein

## Wat je krijgt

`build/admin-strato/website/` bevat uitsluitend de vier openbare websitebestanden.
`build/admin-strato-upload.zip` bevat dezelfde bestanden direct in de ZIP-root.
Je hoeft geen Flutter, Node.js, PHP of database op Strato te installeren voor
het uitvoeren van deze website. Je hebt webspace nodig waarop statische HTML,
JavaScript en CSS via HTTPS worden aangeboden; alleen een domeinregistratie
is daarvoor niet voldoende.

De browser gebruikt Firebase Authentication om in te loggen en roept de
beveiligde Firebase Cloud Functions aan. Die controleren de beheerrechten en
lezen/wijzigen Authentication-accounts en Firestore-profielen. De browser krijgt
geen directe beheertoegang tot Firestore.

Het pakket bevat de huidige openbare configuratie van Firebase-project
`base-app-f5a6e`. Hiermee is de verbinding ingesteld; dit bewijst niet dat de
beheerbackend al in dat project is gedeployed. Er worden geen wachtwoorden,
serviceaccountkeys of beheerdersrechten meegeleverd.

## 1. Firebase eenmalig gereedmaken

Volg [de volledige Firebase-installatie](admin-web-app-setup.md) in de repository.
In het kort:

1. Controleer `admin-web/config.js`: project en regio moeten overeenkomen met
   de backend. Voor een afgeleide app vervang je deze configuratie.
2. Installeer dependencies met Node 22: `npm ci --prefix functions`.
3. Controleer billing (Blaze), projectkeuze en regio voordat je Cloud Functions
   deployt. Deploy vanuit de repository:

   ```sh
   firebase deploy --project base-app-f5a6e --config firebase.admin.json --only firestore:rules,functions:admin
   ```

   Dit deployt geen Firebase Hosting-site. Voor een ander project vervang je
   expliciet de project-ID in dit commando en de websiteconfiguratie.
4. Wijs het eerste actieve, geverifieerde persoonlijke account als admin aan
   met Application Default Credentials voor een bevoegde projectoperator:

   ```sh
   npm run bootstrap --prefix functions -- base-app-f5a6e UID
   ```

   Vervang `UID` door de echte Authentication-UID. De eerste beheerinterface
   ondersteunt e-mail/wachtwoordlogin; gebruik een account met die provider.
   De emulatoraccounts bestaan niet in productie.
5. Voeg het exacte Strato-subdomein, zonder protocol of pad, toe onder
   Firebase Console → Authentication → Settings → Authorized domains.

## 2. Uploadpakket maken

Voer vanuit de repository uit:

```sh
python3 tool/package_admin_web.py
```

Maak het pakket opnieuw na iedere website- of configuratiewijziging.
Het pakket is een kopie; wijzigingen in de bronbestanden verschijnen pas na
opnieuw verpakken en uploaden op Strato.

## 3. Strato instellen

1. Maak in je eigen Strato-beheer een subdomein aan, bijvoorbeeld
   `beheer.jouwdomein.nl`, en koppel dat aan een eigen webspace-map.
   Gebruik een aparte map om je bestaande website niet te overschrijven.
2. Activeer HTTPS voor het subdomein en controleer dat het certificaat geldig is.
3. Upload de **inhoud** van `website/` naar die map, via je gebruikelijke
   SFTP-/FTP-client of bestandsbeheer. `index.html` moet direct in de documentroot
   van het subdomein staan. Je kunt ook de ZIP lokaal uitpakken en die bestanden
   uploaden. Een ZIP uploaden alleen installeert de website niet automatisch.
4. Upload geen `functions/`, `node_modules/`, credentials of de hele repository.
5. Open de HTTPS-URL zonder `?emulator=1`. Inloggen gebruikt nu echte Firebase-accounts.

De precieze menunamen hangen af van je Strato-product. Er is geen Strato-account
of domeinconfiguratie vanuit deze implementatie aangepast.

## 4. Controle na upload

- Controleer dat `index.html`, `app.js`, `config.js` en `styles.css` laden.
  Modules moeten met een JavaScript-MIME-type aangeboden worden.
- Log in met je persoonlijke adminaccount en open een gebruiker.
- Wijzig taal/thema/profielstatus van een testgebruiker en laad opnieuw.
- Controleer hetzelfde profiel in de gebruikersapp.
- Test een gebruikersbeheerder en controleer dat een gewone user geen beheertoegang heeft.
- Test desktop/macOS en browsers op fysieke iOS- en Android-apparaten.
- Test geen emulatoraccounts op deze website: ze bestaan alleen lokaal.
- Bij een oude versie: herlaad zonder cache. Strato-cacheheaders worden niet
  overgenomen uit `firebase.admin.json`; die headers gelden alleen voor Firebase Hosting.

De backend moet vanaf de browser via HTTPS bereikbaar zijn. De huidige callable
functies gebruiken de Firebase-standaard voor CORS; de browser stuurt het
Firebase ID-token mee en de backend controleert de actuele rol. Een toegelaten
domein of bereikbare website geeft op zichzelf geen beheerrechten.

Deze oplevering maakt alleen het uploadpakket. Deployment naar Firebase,
rollen toekennen en uploaden naar Strato zijn hiermee nog niet uitgevoerd.
