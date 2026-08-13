// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get login => 'Log in';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get createNewAccount => 'Create a new account';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get googleSignInPreparing => 'Preparing Google sign-in…';

  @override
  String googleSignInUnavailable(String error) {
    return 'Google sign-in is unavailable: $error';
  }

  @override
  String get register => 'Register';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get createAccount => 'Create account';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match.';

  @override
  String errorWithDetails(String error) {
    return 'Something went wrong: $error';
  }

  @override
  String get home => 'Home';

  @override
  String get welcome => 'Welcome';

  @override
  String get noEmail => 'No email address';

  @override
  String get noName => 'No name';

  @override
  String get noUid => 'No user ID';

  @override
  String get signOut => 'Sign out';

  @override
  String get menu => 'Menu';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get noProfileFound => 'No profile found';

  @override
  String get appLanguage => 'App language';

  @override
  String get dutch => 'Dutch';

  @override
  String get english => 'English';

  @override
  String get languageSaveFailed => 'The language could not be saved.';

  @override
  String themeValue(String value) {
    return 'Theme: $value';
  }

  @override
  String profileCompleteValue(String value) {
    return 'Profile complete: $value';
  }

  @override
  String createdAtValue(String value) {
    return 'Created: $value';
  }

  @override
  String lastLoginValue(String value) {
    return 'Last login: $value';
  }

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get notAvailable => 'Not available';

  @override
  String get theme => 'Theme';

  @override
  String get systemTheme => 'System';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String versionValue(String value) {
    return 'Version: $value';
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
    return 'Built: $value';
  }

  @override
  String platformValue(String value) {
    return 'Platform: $value';
  }
}
