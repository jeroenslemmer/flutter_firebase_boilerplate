// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get login => 'Inloggen';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Wachtwoord';

  @override
  String get createNewAccount => 'Nieuw account maken';

  @override
  String get signInWithGoogle => 'Inloggen met Google';

  @override
  String get googleSignInPreparing => 'Inloggen met Google voorbereiden…';

  @override
  String googleSignInUnavailable(String error) {
    return 'Inloggen met Google is niet beschikbaar: $error';
  }

  @override
  String get register => 'Registreren';

  @override
  String get confirmPassword => 'Bevestig wachtwoord';

  @override
  String get createAccount => 'Account maken';

  @override
  String get passwordsDoNotMatch => 'Wachtwoorden komen niet overeen.';

  @override
  String errorWithDetails(String error) {
    return 'Er is iets misgegaan: $error';
  }

  @override
  String get home => 'Home';

  @override
  String get welcome => 'Welkom';

  @override
  String get noEmail => 'Geen e-mailadres';

  @override
  String get noName => 'Geen naam';

  @override
  String get noUid => 'Geen gebruikers-ID';

  @override
  String get signOut => 'Uitloggen';

  @override
  String get menu => 'Menu';

  @override
  String get profile => 'Profiel';

  @override
  String get settings => 'Instellingen';

  @override
  String get noProfileFound => 'Geen profiel gevonden';

  @override
  String get appLanguage => 'App-taal';

  @override
  String get dutch => 'Nederlands';

  @override
  String get english => 'Engels';

  @override
  String get languageSaveFailed => 'De taal kon niet worden opgeslagen.';

  @override
  String themeValue(String value) {
    return 'Thema: $value';
  }

  @override
  String profileCompleteValue(String value) {
    return 'Profiel compleet: $value';
  }

  @override
  String createdAtValue(String value) {
    return 'Aangemaakt: $value';
  }

  @override
  String lastLoginValue(String value) {
    return 'Laatste login: $value';
  }

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nee';

  @override
  String get notAvailable => 'Niet beschikbaar';

  @override
  String get theme => 'Thema';

  @override
  String get systemTheme => 'Systeem';

  @override
  String get lightTheme => 'Licht';

  @override
  String get darkTheme => 'Donker';

  @override
  String versionValue(String value) {
    return 'Versie: $value';
  }

  @override
  String branchValue(String value) {
    return 'Branch: $value';
  }

  @override
  String commitValue(String value) {
    return 'Commit: $value';
  }

  @override
  String builtValue(String value) {
    return 'Gebouwd: $value';
  }

  @override
  String platformValue(String value) {
    return 'Platform: $value';
  }
}
