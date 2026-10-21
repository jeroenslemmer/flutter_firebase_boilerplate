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

  @override
  String get forgotPassword => 'Wachtwoord vergeten?';

  @override
  String get resetPassword => 'Wachtwoord herstellen';

  @override
  String get passwordResetInstructions =>
      'Vul je e-mailadres in. Als er een account bestaat, ontvang je een link om je wachtwoord opnieuw in te stellen.';

  @override
  String get sendResetEmail => 'Herstellink versturen';

  @override
  String get passwordResetEmailSent =>
      'Als er een account voor dit e-mailadres bestaat, is een herstellink verzonden.';

  @override
  String get backToLogin => 'Terug naar inloggen';

  @override
  String get enterValidEmail => 'Vul een geldig e-mailadres in.';

  @override
  String get enterPassword => 'Vul je wachtwoord in.';

  @override
  String get passwordMinimumLength => 'Gebruik minimaal 6 tekens.';

  @override
  String get enterPasswordConfirmation => 'Herhaal je wachtwoord.';

  @override
  String get verifyEmail => 'Bevestig je e-mailadres';

  @override
  String verificationEmailInstructions(String email) {
    return 'We hebben een bevestigingslink gestuurd naar $email. Open de link en kom daarna terug naar de app.';
  }

  @override
  String get iHaveVerifiedEmail => 'Ik heb mijn e-mail bevestigd';

  @override
  String get resendVerificationEmail => 'Bevestigingsmail opnieuw versturen';

  @override
  String get verificationEmailResent =>
      'De bevestigingsmail is opnieuw verstuurd.';

  @override
  String get emailNotVerifiedYet => 'Je e-mailadres is nog niet bevestigd.';

  @override
  String get signInWithApple => 'Inloggen met Apple';

  @override
  String get account => 'Account';

  @override
  String get deleteAccount => 'Account verwijderen';

  @override
  String get deleteAccountWarning =>
      'Je account en profiel worden permanent verwijderd. Deze actie kan niet ongedaan worden gemaakt.';

  @override
  String get currentPassword => 'Huidig wachtwoord';

  @override
  String get cancel => 'Annuleren';

  @override
  String get deletePermanently => 'Permanent verwijderen';

  @override
  String get authErrorInvalidEmail => 'Het e-mailadres is ongeldig.';

  @override
  String get authErrorInvalidCredential =>
      'Het e-mailadres of wachtwoord is onjuist.';

  @override
  String get authErrorEmailAlreadyInUse =>
      'Er bestaat al een account met dit e-mailadres.';

  @override
  String get authErrorWeakPassword => 'Kies een sterker wachtwoord.';

  @override
  String get authErrorUserDisabled => 'Dit account is uitgeschakeld.';

  @override
  String get authErrorTooManyRequests =>
      'Te veel pogingen. Probeer het later opnieuw.';

  @override
  String get authErrorNetwork =>
      'Controleer je internetverbinding en probeer het opnieuw.';

  @override
  String get authErrorOperationNotAllowed =>
      'Deze inlogmethode is nog niet beschikbaar.';

  @override
  String get authErrorRequiresRecentLogin =>
      'Log opnieuw in om deze gevoelige actie uit te voeren.';

  @override
  String get authErrorPasswordRequired => 'Vul je huidige wachtwoord in.';

  @override
  String get authErrorUnsupportedProvider =>
      'Dit account gebruikt een niet-ondersteunde inlogmethode.';

  @override
  String get authErrorCancelled => 'Het inloggen is geannuleerd.';

  @override
  String get authErrorUnknown =>
      'Authenticatie is mislukt. Probeer het opnieuw.';

  @override
  String get profileSyncFailed =>
      'Je bent ingelogd, maar je profiel kon niet worden geladen. Probeer het opnieuw.';

  @override
  String get profileSyncPermissionDenied =>
      'Je bent ingelogd, maar Firestore weigert toegang tot je profiel. Controleer de gedeployde security rules.';

  @override
  String get profileSyncUnavailable =>
      'Je bent ingelogd, maar de profielopslag is tijdelijk niet bereikbaar.';

  @override
  String get authErrorKeychain =>
      'Firebase kan de macOS-sleutelhanger niet gebruiken. Controleer Keychain Sharing en de Apple-ondertekening.';
}
