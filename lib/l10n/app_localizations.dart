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

  /// No description provided for @login.
  ///
  /// In nl, this message translates to:
  /// **'Inloggen'**
  String get login;

  /// No description provided for @email.
  ///
  /// In nl, this message translates to:
  /// **'E-mail'**
  String get email;

  /// No description provided for @password.
  ///
  /// In nl, this message translates to:
  /// **'Wachtwoord'**
  String get password;

  /// No description provided for @createNewAccount.
  ///
  /// In nl, this message translates to:
  /// **'Nieuw account maken'**
  String get createNewAccount;

  /// No description provided for @signInWithGoogle.
  ///
  /// In nl, this message translates to:
  /// **'Inloggen met Google'**
  String get signInWithGoogle;

  /// No description provided for @googleSignInPreparing.
  ///
  /// In nl, this message translates to:
  /// **'Inloggen met Google voorbereiden…'**
  String get googleSignInPreparing;

  /// No description provided for @googleSignInUnavailable.
  ///
  /// In nl, this message translates to:
  /// **'Inloggen met Google is niet beschikbaar: {error}'**
  String googleSignInUnavailable(String error);

  /// No description provided for @register.
  ///
  /// In nl, this message translates to:
  /// **'Registreren'**
  String get register;

  /// No description provided for @confirmPassword.
  ///
  /// In nl, this message translates to:
  /// **'Bevestig wachtwoord'**
  String get confirmPassword;

  /// No description provided for @createAccount.
  ///
  /// In nl, this message translates to:
  /// **'Account maken'**
  String get createAccount;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In nl, this message translates to:
  /// **'Wachtwoorden komen niet overeen.'**
  String get passwordsDoNotMatch;

  /// No description provided for @errorWithDetails.
  ///
  /// In nl, this message translates to:
  /// **'Er is iets misgegaan: {error}'**
  String errorWithDetails(String error);

  /// No description provided for @home.
  ///
  /// In nl, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @welcome.
  ///
  /// In nl, this message translates to:
  /// **'Welkom'**
  String get welcome;

  /// No description provided for @noEmail.
  ///
  /// In nl, this message translates to:
  /// **'Geen e-mailadres'**
  String get noEmail;

  /// No description provided for @noName.
  ///
  /// In nl, this message translates to:
  /// **'Geen naam'**
  String get noName;

  /// No description provided for @noUid.
  ///
  /// In nl, this message translates to:
  /// **'Geen gebruikers-ID'**
  String get noUid;

  /// No description provided for @signOut.
  ///
  /// In nl, this message translates to:
  /// **'Uitloggen'**
  String get signOut;

  /// No description provided for @menu.
  ///
  /// In nl, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @profile.
  ///
  /// In nl, this message translates to:
  /// **'Profiel'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In nl, this message translates to:
  /// **'Instellingen'**
  String get settings;

  /// No description provided for @noProfileFound.
  ///
  /// In nl, this message translates to:
  /// **'Geen profiel gevonden'**
  String get noProfileFound;

  /// No description provided for @appLanguage.
  ///
  /// In nl, this message translates to:
  /// **'App-taal'**
  String get appLanguage;

  /// No description provided for @dutch.
  ///
  /// In nl, this message translates to:
  /// **'Nederlands'**
  String get dutch;

  /// No description provided for @english.
  ///
  /// In nl, this message translates to:
  /// **'Engels'**
  String get english;

  /// No description provided for @languageSaveFailed.
  ///
  /// In nl, this message translates to:
  /// **'De taal kon niet worden opgeslagen.'**
  String get languageSaveFailed;

  /// No description provided for @themeValue.
  ///
  /// In nl, this message translates to:
  /// **'Thema: {value}'**
  String themeValue(String value);

  /// No description provided for @profileCompleteValue.
  ///
  /// In nl, this message translates to:
  /// **'Profiel compleet: {value}'**
  String profileCompleteValue(String value);

  /// No description provided for @createdAtValue.
  ///
  /// In nl, this message translates to:
  /// **'Aangemaakt: {value}'**
  String createdAtValue(String value);

  /// No description provided for @lastLoginValue.
  ///
  /// In nl, this message translates to:
  /// **'Laatste login: {value}'**
  String lastLoginValue(String value);

  /// No description provided for @yes.
  ///
  /// In nl, this message translates to:
  /// **'Ja'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In nl, this message translates to:
  /// **'Nee'**
  String get no;

  /// No description provided for @notAvailable.
  ///
  /// In nl, this message translates to:
  /// **'Niet beschikbaar'**
  String get notAvailable;

  /// No description provided for @theme.
  ///
  /// In nl, this message translates to:
  /// **'Thema'**
  String get theme;

  /// No description provided for @systemTheme.
  ///
  /// In nl, this message translates to:
  /// **'Systeem'**
  String get systemTheme;

  /// No description provided for @lightTheme.
  ///
  /// In nl, this message translates to:
  /// **'Licht'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In nl, this message translates to:
  /// **'Donker'**
  String get darkTheme;

  /// No description provided for @versionValue.
  ///
  /// In nl, this message translates to:
  /// **'Versie: {value}'**
  String versionValue(String value);

  /// No description provided for @branchValue.
  ///
  /// In nl, this message translates to:
  /// **'Branch: {value}'**
  String branchValue(String value);

  /// No description provided for @commitValue.
  ///
  /// In nl, this message translates to:
  /// **'Commit: {value}'**
  String commitValue(String value);

  /// No description provided for @builtValue.
  ///
  /// In nl, this message translates to:
  /// **'Gebouwd: {value}'**
  String builtValue(String value);

  /// No description provided for @platformValue.
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
