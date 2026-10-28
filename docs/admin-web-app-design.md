# Beheerwebapp: eerste implementatie

Een aparte, optionele website in `admin-web/` met een Firebase callable backend
in `functions/`. Gebruikersapp en beheerwebsite delen binnen één afgeleide app
hetzelfde Firebase-project. Iedere afgeleide app krijgt eigen configuratie.
De beheerwebsite heeft een eigen Hosting-site en deploymentconfiguratie.

## Rollen

| Rol | Bevoegdheden |
| --- | --- |
| Admin | Alle accounts en profielen bekijken en profielen aanpassen; rollen van anderen wijzigen |
| Gebruikersbeheerder (`user-manager`) | Alleen gewone users bekijken, hun profielen aanpassen en blokkeren/deblokkeren |
| User | Eigen profiel beheren in de gebruikersapp |

Admins kunnen gewone users eveneens blokkeren/deblokkeren. Bevoorrechte
accounts moeten eerst worden teruggezet naar user. Zelf blokkeren of de eigen
rol wijzigen is niet mogelijk. Accounts worden niet verwijderd via deze eerste versie.

## Schermen

- Persoonlijk aanmelden met e-mail/wachtwoord, met wachtwoordherstel.
- Gebruikersoverzicht met paginering, zoeken op exact e-mailadres of UID,
  providers, rol en accountstatus.
- Accountdetail met verificatie, datums en UID.
- Firestore-profiel aanpassen: taal, thema en profielstatus.
- Rollen wijzigen voor admins, met bevestiging.
- Blokkeren/deblokkeren met bevestiging en uitleg over bestaande sessies.

Desktop gebruikt twee kolommen; smalle schermen tonen gebruikers en details
onder elkaar. De beheerinterface is Nederlandstalig. NL/EN/FR zijn beschikbaar
als profieltaal voor de Flutter-gebruikersapp. Er zijn geen native beheerbuilds.

## Beveiliging

`adminAccess/{uid}` is de gezaghebbende, voor clients afgeschermde rolregistratie.
De backend leest deze bij iedere aanvraag en spiegelt rollen naar custom claims.
Een user heeft geen recht om rollen of auditrecords te lezen of te schrijven.
Firestore-profielen blijven eigenaargebonden voor de gewone client.

Profiel- en rolwijzigingen worden samen met hun auditrecord opgeslagen.
Auth-blokkeeracties krijgen eerst een pending registratie en vergrendeling;
gedeeltelijke fouten vereisen controle door een bevoegde projectoperator.
Beheerlogboek bekijken gebeurt vooralsnog in Firestore Console.

## Validatie op 28 oktober 2026

- 11 backendtests geslaagd met Auth-/Firestore-emulators, zonder overgeslagen tests.
- 14 Firestore-regeltests geslaagd, inclusief weigeren van rolwijzigingen vanuit
  clients en ondersteuning voor Franse profielen.
- Flutter-analyse schoon; alle 19 Flutter-tests geslaagd.
- Browserflow op macOS met lokaal demo-project: aanmelden, gebruikersoverzicht,
  accountdetail en succesvol wijzigen van profieltaal/thema via de callable backend.
- Desktop- en smalle browserindeling visueel gecontroleerd.
- Fysieke iOS-/Android-browsertests en de profielwijziging terugzien in de native
  gebruikersapps zijn nog niet uitgevoerd. Responsive controle vervangt die niet.
- Geen productiebackend, Hosting of regels gedeployed; geen echte rollen toegewezen.

## Installatie en openstaande acceptatie

Zie [installatie en handmatige tests](admin-web-app-setup.md) voor de exacte
commando's, bootstrap van het eerste adminaccount en afzonderlijke deployment.
De Action URL-aanvraag bij Firebase Support en echte e-mailtests voor de
gebruikersapp blijven een aparte openstaande taak.

Deze implementatie en documentatie horen bij één beheerfunctionaliteit en zijn
nog niet gecommit. Een volgende losstaande functie krijgt een eigen commit.
