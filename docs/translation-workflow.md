# Git-workflow voor vertalingen

De ARB-bestanden in `lib/l10n` zijn de enige bron van waarheid voor teksten in
de app. Vertalingen worden via een aparte Git-branch en pull- of merge request
aangeleverd. Er is geen vertaalplatform of hostingabonnement nodig.

## Rollen

### Ontwikkelaar

- voegt sleutels en Nederlandse bronteksten toe aan `app_nl.arb`;
- schrijft bij iedere brontekst een begrijpelijke `description`;
- definieert placeholders en hun typen;
- past Dart-code en schermen aan;
- beoordeelt of de vertaling technisch veilig is.

### Vertaler

- vertaalt uitsluitend waarden in het toegewezen `app_<taal>.arb`-bestand;
- wijzigt geen sleutels, metadata of tekst tussen accolades;
- werkt altijd in een eigen branch;
- levert het resultaat aan via een pull- of merge request.

## Een vertaling uitvoeren

### Aanbevolen: lokale editor vanuit VS Code

De vertaler hoeft het ARB-bestand niet rechtstreeks te bewerken:

1. Open het project in Visual Studio Code.
2. Kies **Terminal → Run Task**.
3. Kies **Translations: Edit English** of **Translations: Edit language…**.
4. De lokale vertaaleditor opent automatisch in de browser.
5. Selecteer links een tekst en wijzig alleen het veld **Vertaling**.
6. Los eventuele placeholderwaarschuwingen op.
7. Kies **Wijzigingen opslaan**.
8. Stop de VS Code-taak met de prullenbakknop in de terminal.
9. Controleer de wijzigingen in Source Control en maak een commit.

De editor draait alleen op `127.0.0.1`, gebruikt geen database of externe
hosting en schrijft rechtstreeks naar het gekozen `app_<taal>.arb`-bestand.
Bronteksten, sleutels en metadata zijn alleen-lezen. De server valideert alle
sleutels en placeholders opnieuw voordat het bestand wordt opgeslagen.

### Alternatief: rechtstreeks via de Git-webinterface

De exacte knoppen verschillen tussen GitHub, GitLab en andere Git-providers,
maar de stappen zijn hetzelfde:

1. Open de repository via de ontvangen link.
2. Maak een branch met de naam `translations/<taal>-<korte-omschrijving>`,
   bijvoorbeeld `translations/en-login`.
3. Open `lib/l10n/app_en.arb`.
4. Kies **Edit** of **Bewerken**.
5. Wijzig alleen de Engelse tekst rechts van de dubbele punt.
6. Laat namen zoals `login`, `errorWithDetails` en `themeValue` ongewijzigd.
7. Laat tekst tussen accolades exact staan, bijvoorbeeld `{error}` en `{value}`.
8. Sla de wijziging op in de aangemaakte branch.
9. Open een pull request of merge request.
10. Beschrijf welke teksten zijn vertaald en meld onduidelijkheden als commentaar.

Voorbeeld van een toegestane wijziging:

```diff
-  "login": "Log in",
+  "login": "Sign in",
```

Niet toegestaan:

```diff
-  "errorWithDetails": "Something went wrong: {error}",
+  "foutMetDetails": "Something went wrong: {problem}",
```

Hier zijn zowel de sleutel als de verplichte placeholder gewijzigd.

## Een nieuwe taal toevoegen

Een ontwikkelaar kopieert eerst het volledige brontaalbestand naar
`lib/l10n/app_<locale>.arb`, zet `@@locale` op de nieuwe locale en verwijdert de
Nederlandse metadata uit het vertaalbestand indien gewenst. Daarna vertaalt de
vertaler alleen de berichtwaarden. Voorbeelden zijn `app_de.arb` en
`app_fr.arb`.

De app ondersteunt een nieuwe taal pas nadat ook de taalkeuze en de toegestane
taalwaarden in het gebruikersprofiel en de Firestore Rules zijn uitgebreid.

## Verplichte controle

Voer voor iedere vertaalwijziging uit:

```bash
dart run tool/check_translations.dart
flutter gen-l10n
flutter analyze
flutter test
```

De vertaalcontrole weigert onder meer:

- ontbrekende of onbekende vertaalsleutels;
- gewijzigde of verwijderde placeholders;
- ontbrekende context bij Nederlandse bronteksten;
- ontbrekende placeholdertypen en -beschrijvingen;
- een locale die niet overeenkomt met de bestandsnaam;
- ongeldige ARB/JSON.

## Reviewchecklist

- [ ] Alleen het bedoelde `app_<taal>.arb` is door de vertaler gewijzigd.
- [ ] Sleutels en placeholders zijn ongewijzigd.
- [ ] Terminologie is consistent met bestaande schermen.
- [ ] Knopteksten zijn kort genoeg voor kleine mobiele schermen.
- [ ] De vertaling is begrijpelijk zonder woord-voor-woordvertaling.
- [ ] Alle vier de controleopdrachten slagen.
- [ ] De vertaling is indien mogelijk visueel in de app gecontroleerd.

## Conflicten

Als een ontwikkelaar tijdens de vertaling de Nederlandse catalogus wijzigt,
wordt de vertaalbranch eerst bijgewerkt met de doelbranch. De validator toont
vervolgens welke nieuwe vertalingen nog ontbreken. Een vertaler lost geen
conflicten in sleutels of metadata zelfstandig op; dat doet een ontwikkelaar.
