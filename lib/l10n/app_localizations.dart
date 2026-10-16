import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_nl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('nl'),
  ];

  /// Primaire knop waarmee de gebruiker inlogt.
  ///
  /// In nl, this message translates to:
  /// **'Inloggen'**
  String get login;

  /// Label voor het veld waarin de gebruiker het e-mailadres invoert.
  ///
  /// In nl, this message translates to:
  /// **'E-mail'**
  String get email;

  /// Label voor het wachtwoordveld.
  ///
  /// In nl, this message translates to:
  /// **'Wachtwoord'**
  String get password;

  /// Actie waarmee een gebruiker naar registratie gaat.
  ///
  /// In nl, this message translates to:
  /// **'Nieuw account maken'**
  String get createNewAccount;

  /// Knoptekst voor aanmelden met een Google-account.
  ///
  /// In nl, this message translates to:
  /// **'Inloggen met Google'**
  String get signInWithGoogle;

  /// Tijdelijke status terwijl Google Sign-In wordt voorbereid.
  ///
  /// In nl, this message translates to:
  /// **'Inloggen met Google voorbereiden…'**
  String get googleSignInPreparing;

  /// Foutmelding wanneer Google Sign-In niet gestart kan worden. Laat {error} ongewijzigd.
  ///
  /// In nl, this message translates to:
  /// **'Inloggen met Google is niet beschikbaar: {error}'**
  String googleSignInUnavailable(String error);

  /// Titel of actie voor het registratiescherm.
  ///
  /// In nl, this message translates to:
  /// **'Registreren'**
  String get register;

  /// Label voor het veld waarin het wachtwoord wordt herhaald.
  ///
  /// In nl, this message translates to:
  /// **'Bevestig wachtwoord'**
  String get confirmPassword;

  /// Primaire knop waarmee een nieuw account wordt aangemaakt.
  ///
  /// In nl, this message translates to:
  /// **'Account maken'**
  String get createAccount;

  /// Validatiefout wanneer de twee ingevoerde wachtwoorden verschillen.
  ///
  /// In nl, this message translates to:
  /// **'Wachtwoorden komen niet overeen.'**
  String get passwordsDoNotMatch;

  /// Algemene foutmelding met technische details. Laat {error} ongewijzigd.
  ///
  /// In nl, this message translates to:
  /// **'Er is iets misgegaan: {error}'**
  String errorWithDetails(String error);

  /// Naam van de hoofdpagina in de navigatie.
  ///
  /// In nl, this message translates to:
  /// **'Home'**
  String get home;

  /// Begroeting op de hoofdpagina.
  ///
  /// In nl, this message translates to:
  /// **'Welkom'**
  String get welcome;

  /// Vervangende tekst wanneer geen e-mailadres bekend is.
  ///
  /// In nl, this message translates to:
  /// **'Geen e-mailadres'**
  String get noEmail;

  /// Vervangende tekst wanneer geen naam bekend is.
  ///
  /// In nl, this message translates to:
  /// **'Geen naam'**
  String get noName;

  /// Vervangende tekst wanneer geen gebruikers-ID bekend is.
  ///
  /// In nl, this message translates to:
  /// **'Geen gebruikers-ID'**
  String get noUid;

  /// Actie waarmee de gebruiker uitlogt.
  ///
  /// In nl, this message translates to:
  /// **'Uitloggen'**
  String get signOut;

  /// Toegankelijkheidslabel voor de menuknop.
  ///
  /// In nl, this message translates to:
  /// **'Menu'**
  String get menu;

  /// Titel en navigatielabel van het gebruikersprofiel.
  ///
  /// In nl, this message translates to:
  /// **'Profiel'**
  String get profile;

  /// Titel en navigatielabel van de instellingenpagina.
  ///
  /// In nl, this message translates to:
  /// **'Instellingen'**
  String get settings;

  /// Melding wanneer het profiel van de gebruiker ontbreekt.
  ///
  /// In nl, this message translates to:
  /// **'Geen profiel gevonden'**
  String get noProfileFound;

  /// Label voor de instelling waarmee de taal van de app wordt gekozen.
  ///
  /// In nl, this message translates to:
  /// **'App-taal'**
  String get appLanguage;

  /// Naam van de Nederlandse taal in een taalkeuzelijst.
  ///
  /// In nl, this message translates to:
  /// **'Nederlands'**
  String get dutch;

  /// Naam van de Engelse taal in een taalkeuzelijst.
  ///
  /// In nl, this message translates to:
  /// **'Engels'**
  String get english;

  /// Foutmelding wanneer het opslaan van de gekozen app-taal mislukt.
  ///
  /// In nl, this message translates to:
  /// **'De taal kon niet worden opgeslagen.'**
  String get languageSaveFailed;

  /// Toont het momenteel ingestelde thema. Laat {value} ongewijzigd.
  ///
  /// In nl, this message translates to:
  /// **'Thema: {value}'**
  String themeValue(String value);

  /// Geeft aan of het gebruikersprofiel compleet is. Laat {value} ongewijzigd.
  ///
  /// In nl, this message translates to:
  /// **'Profiel compleet: {value}'**
  String profileCompleteValue(String value);

  /// Toont wanneer het profiel is aangemaakt. Laat {value} ongewijzigd.
  ///
  /// In nl, this message translates to:
  /// **'Aangemaakt: {value}'**
  String createdAtValue(String value);

  /// Toont het tijdstip van de laatste login. Laat {value} ongewijzigd.
  ///
  /// In nl, this message translates to:
  /// **'Laatste login: {value}'**
  String lastLoginValue(String value);

  /// Bevestigende waarde voor een boolean.
  ///
  /// In nl, this message translates to:
  /// **'Ja'**
  String get yes;

  /// Ontkennende waarde voor een boolean.
  ///
  /// In nl, this message translates to:
  /// **'Nee'**
  String get no;

  /// Vervangende tekst wanneer een waarde niet beschikbaar is.
  ///
  /// In nl, this message translates to:
  /// **'Niet beschikbaar'**
  String get notAvailable;

  /// Titel van de thema-instellingen.
  ///
  /// In nl, this message translates to:
  /// **'Thema'**
  String get theme;

  /// Thema-optie die de systeeminstelling van het apparaat volgt.
  ///
  /// In nl, this message translates to:
  /// **'Systeem'**
  String get systemTheme;

  /// Naam van het lichte kleurenthema.
  ///
  /// In nl, this message translates to:
  /// **'Licht'**
  String get lightTheme;

  /// Naam van het donkere kleurenthema.
  ///
  /// In nl, this message translates to:
  /// **'Donker'**
  String get darkTheme;

  /// Debug-informatie met het versienummer. Laat {value} ongewijzigd.
  ///
  /// In nl, this message translates to:
  /// **'Versie: {value}'**
  String versionValue(String value);

  /// Debug-informatie met de Git-branch. Laat {value} ongewijzigd.
  ///
  /// In nl, this message translates to:
  /// **'Branch: {value}'**
  String branchValue(String value);

  /// Debug-informatie met de Git-commit. Laat {value} ongewijzigd.
  ///
  /// In nl, this message translates to:
  /// **'Commit: {value}'**
  String commitValue(String value);

  /// Debug-informatie met het buildtijdstip. Laat {value} ongewijzigd.
  ///
  /// In nl, this message translates to:
  /// **'Gebouwd: {value}'**
  String builtValue(String value);

  /// Debug-informatie met het actieve platform. Laat {value} ongewijzigd.
  ///
  /// In nl, this message translates to:
  /// **'Platform: {value}'**
  String platformValue(String value);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'nl':
      return AppLocalizationsNl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
