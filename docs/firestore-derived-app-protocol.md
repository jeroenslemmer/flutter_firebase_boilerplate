# Protocol: Firestore voor een afgeleide app

Dit protocol is de verplichte volgorde voor iedere app die van deze boilerplate
wordt afgeleid. Het doel is dat het datamodel, de clientcode en de Security Rules
dezelfde afspraken hanteren en dat nieuwe collecties standaard gesloten blijven.

## Uitgangspunten

1. De mobiele of webclient is niet vertrouwd.
2. Authenticatie is geen autorisatie: ingelogd zijn geeft niet automatisch
   toegang tot documenten.
3. Firestore Security Rules zijn de autorisatiegrens voor client-SDK's.
4. Niet gedeclareerde paden blijven gesloten.
5. Iedere toegestane actie heeft minimaal een positieve en een negatieve test.
6. De Admin SDK en serverbibliotheken omzeilen Security Rules. Beveilig een
   backend daarom apart met IAM en controleer daar zelf de autorisatie.

## Stap 1: beschrijf het datamodel zonder code

Maak voor iedere collectie eerst een korte modelspecificatie. Gebruik per veld:

| Onderdeel | Beschrijving |
|---|---|
| Pad | Bijvoorbeeld `/projects/{projectId}` |
| Eigenaar | Gebruiker, organisatie, publiek of alleen backend |
| Velden | Naam, Firestore-type, verplicht/optioneel en standaardwaarde |
| Door client wijzigbaar | Welke velden een client mag aanmaken of wijzigen |
| Alleen backend | Rollen, betaling, moderation state en andere vertrouwde data |
| Levenscyclus | Wie mag aanmaken, lezen, wijzigen en verwijderen |
| Query's | Exacte filters, sortering en paginering die de app nodig heeft |
| Retentie | Wanneer en door wie gegevens worden verwijderd |

Gebruik server-timestamps voor auditvelden zoals `createdAt` en `updatedAt`.
Zet autorisatiegegevens niet uitsluitend in een document dat de gebruiker zelf
mag wijzigen.

## Stap 2: maak een toegangsmatrix

Schrijf per documenttype en rol expliciet `create`, `get`, `list`, `update` en
`delete` uit. Splits `get` en `list`: een gebruiker kan bijvoorbeeld zijn eigen
profiel direct ophalen zonder alle gebruikers te mogen doorzoeken.

Voorbeeld:

| Pad | Actor | Create | Get | List | Update | Delete |
|---|---|---:|---:|---:|---:|---:|
| `/users/{uid}` | eigenaar | ja | ja | nee | veilige velden | ja |
| `/users/{uid}` | andere gebruiker | nee | nee | nee | nee | nee |
| `/users/{uid}` | anoniem | nee | nee | nee | nee | nee |

Een beslissing die niet in de matrix staat, is standaard `nee`.

## Stap 3: kies het eigendomsmodel

Gebruik één van deze patronen en documenteer de keuze:

- **Privé per gebruiker:** het documentpad of een onveranderlijk `ownerId` bevat
  de Firebase Auth-UID.
- **Gedeeld team:** lidmaatschap en rol staan in een pad dat de gebruiker niet
  zelf kan promoveren, bijvoorbeeld `/teams/{teamId}/members/{uid}`.
- **Publiek leesbaar:** alleen expliciet gepubliceerde documenten zijn leesbaar;
  schrijven blijft beperkt tot eigenaar of backend.
- **Alleen backend:** geen clientregel geeft toegang. Cloud Functions of een
  andere vertrouwde service schrijft via de Admin SDK.

Gebruik custom claims alleen voor kleine, globale rollen. Gebruik ze niet als
grote of vaak veranderende ledenlijst.

## Stap 4: schrijf rules als schema en autorisatie

Voor iedere collectie controleren de rules afzonderlijk:

1. identiteit en eigendom;
2. exact toegestane veldnamen met `hasAll` en `hasOnly`;
3. Firestore-types;
4. enumwaarden en redelijke grenzen voor tekst/getallen;
5. onveranderlijke velden via `diff(...).affectedKeys()`;
6. server-timestamps via vergelijking met `request.time`;
7. toegestane queryvormen als `list` nodig is.

Sluit onderaan alle overige paden:

```text
match /{document=**} {
  allow read, write: if false;
}
```

Rules zijn geen filters. Een query moet aantoonbaar alleen documenten kunnen
opleveren die de gebruiker mag lezen; Firestore haalt niet eerst alles op om
verboden resultaten achteraf weg te filteren.

## Stap 5: schrijf tests vóór de clientfeature

Voeg per operatie minimaal toe:

- één geldige actie van de juiste actor;
- dezelfde actie zonder login;
- dezelfde actie als een andere gebruiker;
- ontbrekende verplichte velden;
- onbekende extra velden;
- verkeerde typen en enumwaarden;
- wijziging van eigenaar, rol of auditvelden;
- toegang tot een niet-gedeclareerd pad;
- toegestane en verboden query's, als `list` wordt gebruikt.

Seed testdata met `withSecurityRulesDisabled`; gebruik die bypass nooit in
applicatiecode. Tests gebruiken een `demo-*` project-ID zodat een fout niet naar
een echt Firebase-project kan schrijven.

Lokale uitvoering:

```bash
cd firebase-tests
npm install
npm test
```

Vereisten: Node.js 20 of nieuwer en een JDK 21 of nieuwer. De eerste run kan de
Firestore-emulator downloaden.

## Stap 6: bouw repository en queries tegen het contract

Pas na groene rules-tests wordt de Flutter repository geschreven. Houd daarin:

- collectie- en veldnamen centraal;
- mapping tussen Firestore en domeinmodel expliciet;
- `serverTimestamp()` voor afgedwongen timestamps;
- queryfilters gelijk aan de voorwaarden in de rules;
- Firebase-exceptions vertaald naar domeinfouten;
- server/Admin-logica buiten de client.

Voeg daarna Flutter unit-, widget- of integratietests toe. Die testen appgedrag;
de emulator-tests blijven verantwoordelijk voor de autorisatiegrens.

## Stap 7: behandel schemawijzigingen als migraties

Firestore is schemaloos, maar de app en rules zijn dat niet. Bij ieder nieuw of
gewijzigd veld:

1. bepaal compatibiliteit met bestaande documenten en oudere appversies;
2. pas de modelspecificatie en toegangsmatrix aan;
3. schrijf of wijzig eerst de rules-tests;
4. maak rules tijdelijk compatibel als oude en nieuwe clients tegelijk bestaan;
5. migreer data via een vertrouwde, idempotente backendtaak;
6. verwijder oude velden pas nadat oude clients niet meer ondersteund worden.

Deploy nooit rules die een al gepubliceerde client onverwacht blokkeren.

## Stap 8: valideer en deploy gecontroleerd

Gebruik voor development en productie afzonderlijke Firebase-projecten. Voer
voor iedere deployment uit:

```bash
cd firebase-tests && npm test
flutter analyze
flutter test
firebase deploy --only firestore:rules --project <expliciet-project-id>
```

Gebruik altijd een expliciete project-ID bij deployment. Deploy eerst naar dev,
voer daar een smoke-test uit en deploy daarna exact dezelfde rules naar prod.
Maak een code-review verplicht voor iedere verruiming van toegang.

## Pull-requestchecklist

- [ ] Datamodel en toegangsmatrix zijn bijgewerkt.
- [ ] Nieuwe paden zijn standaard gesloten voor onbevoegde actors.
- [ ] Veldnamen, typen, enums en grenzen worden gevalideerd.
- [ ] Eigenaar-, rol- en auditvelden zijn niet door de client te vervalsen.
- [ ] `get` en `list` zijn afzonderlijk beoordeeld.
- [ ] Positieve en negatieve emulator-tests slagen.
- [ ] Benodigde samengestelde indexen zijn vastgelegd.
- [ ] Migratie en compatibiliteit met bestaande appversies zijn beoordeeld.
- [ ] De deployment gebruikt een expliciete dev- of prodproject-ID.
- [ ] Backendroutes zijn apart met IAM en autorisatie beveiligd.

## Huidig boilerplatecontract

De boilerplate bevat alleen `/users/{uid}`. De eigenaar mag zijn document lezen,
aanmaken, geldige profielvelden wijzigen en verwijderen. Collection queries zijn
uitgeschakeld. De volgende velden zijn verplicht:

| Veld | Type | Beperking |
|---|---|---|
| `createdAt` | timestamp | bij create gelijk aan `request.time`, daarna immutable |
| `lastLogin` | timestamp | bij wijziging gelijk aan `request.time` |
| `profileComplete` | boolean | door eigenaar wijzigbaar |
| `language` | string | `nl` of `en` |
| `themeMode` | string | `system`, `light` of `dark` |

Voeg bij een afgeleide app nieuwe collecties als afzonderlijke, geteste
`match`-blokken toe. Verruim nooit de generieke catch-allregel.
