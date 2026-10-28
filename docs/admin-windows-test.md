# Beheerapp lokaal testen op Windows

Dit pakket draait volledig met lokale Firebase-emulators en drie demo-accounts.
Er is geen Firebase-account, Blaze-abonnement, Strato of productieconfiguratie nodig.
De emulators en website luisteren uitsluitend op deze computer (127.0.0.1).

## Eenmalig installeren

1. Installeer **Node.js 22** vanaf https://nodejs.org/en/download.
   Kies de Windows Installer voor versie 22 en laat toevoegen aan PATH aanstaan.
2. Installeer **Java JDK 21** (of hoger), bijvoorbeeld Eclipse Temurin via
   https://adoptium.net/temurin/releases/?version=21. Kies Windows en de juiste
   processorarchitectuur. Activeer toevoegen aan PATH; stel waar aangeboden JAVA_HOME in.
3. Sluit bestaande terminals na installatie en open ze opnieuw. Controleer zo nodig:

   ```text
   node --version
   java -version
   ```

   Node moet `v22...` tonen; Java moet 21 of hoger zijn. Git, Flutter, Python en
   een apart geïnstalleerde Firebase CLI zijn voor dit pakket niet nodig.
4. Pak **de volledige ZIP** uit, bijvoorbeeld naar `C:\baseapp-test`.
   Start niet rechtstreeks vanuit het ZIP-venster.

## Starten

Dubbelklik op **start.cmd** in de uitgepakte map.

De eerste keer worden npm-dependencies en Firebase-emulatorbestanden gedownload.
Dit kan enkele minuten duren. Er is internet nodig voor deze downloads en voor
het laden van de Firebase-browserbibliotheken. Het pakket is geen offline installer.
Windows-beveiligingssoftware kan toestemming vragen om Node/Java uit te voeren;
volg het beleid van je computerbeheerder en omzeil geen beveiligingsblokkades.

Na het starten worden drie demo-accounts en hun Firestore-profielen klaargezet.
De browser opent automatisch op:

```text
http://127.0.0.1:8787/?emulator=1
```

Dit is lokaal HTTP, geen openbare internetwebsite. Je hoeft voor deze lokale
test geen HTTPS-certificaat in te stellen. De testserver herstelt de emulator-
parameter automatisch als je op het logo klikt of de basis-URL opent.

| Account | Rol |
| --- | --- |
| admin@example.com | Admin |
| manager@example.com | Gebruikersbeheerder |
| ordinary@example.com | User; beheer wordt geweigerd |

Wachtwoord voor alle accounts: **Test-password-42!**

Gebruik uitsluitend demo-accounts en fictieve gegevens. Het venster moet open
blijven tijdens het testen. Stop met **Ctrl+C**; hiermee worden ook de emulator-
processen gestopt. Bij een abrupte crash of sluiten via het kruisje kunnen
processen achterblijven; herstart de computer als een volgende start bezette
poorten meldt en je niet weet welk proces die gebruikt.

## Wat je kunt testen

- Als admin inloggen, accounts zoeken en profielgegevens bekijken.
- Taal, thema en profielstatus van een demo-user wijzigen en opnieuw openen.
- Demo-users blokkeren/deblokkeren en rollen wijzigen.
- Als gebruikersbeheerder alleen gewone users beheren.
- Controleren dat een gewone user geen beheerrechten krijgt.

Opnieuw starten maakt opnieuw demo-accounts/profielen klaar. Testgegevens zijn
tijdelijk en worden niet naar Firebase op internet geschreven. Er is geen
verbinding met de echte Flutter-gebruikersapp of echte Authentication-e-mails.

## Problemen

- **Node/Java ontbreekt:** controleer installatie en PATH; open een nieuwe terminal.
- **Poort bezet:** stop eerdere emulators/testservers. De test gebruikt onder meer
  8787, 9099, 8080, 5001, 4400, 4500 en 9150.
- **Download mislukt:** controleer internet, proxy en firewall. Start daarna opnieuw.
- **Start niet of sluit direct:** open Opdrachtprompt in deze map en voer `start.cmd`
  uit. Deel de zichtbare foutmelding, zonder persoonlijke credentials.
- **Browser opent niet:** open de bovengenoemde lokale URL handmatig.

## Voor ontwikkelaars in de repository

Maak dit pakket met:

```text
python3 tool/package_admin_windows.py
```

Het resultaat is `build/admin-windows-test.zip`. Deel die ZIP, niet de hele
repository. Het pakket bevat geen productieconfiguratie of serviceaccounts.
Het startscript is gericht op Windows, maar de Node-orchestratie kan ook met
`node start.mjs` op macOS/Linux worden gecontroleerd als Node 22 en Java 21+
aanwezig zijn. Op die platformen opent de browser niet automatisch.

De beheerwebsite zelf is hetzelfde als de bestaande webinterface. Dit pakket
voegt geen native iOS-, Android- of macOS-app toe. Controle van echte mobiele
browsers en native gebruikersapps blijft afzonderlijk nodig.

## Uitgevoerde verificatie

Op 28 oktober 2026 is een schone kopie op macOS gestart met Node 22.23.4 en
Java 21, op aparte lokale poorten. Installatie van dependencies, starten van
emulators, drie demo-logins, rolafscherming, een Firestore-profielwijziging
en de automatische emulator-redirect zijn gecontroleerd. De Windows-specifieke
CMD-start en het automatisch openen van de browser zijn nog niet op een echte
Windows-machine getest. Dit is geen fysieke iOS- of Android-test.
