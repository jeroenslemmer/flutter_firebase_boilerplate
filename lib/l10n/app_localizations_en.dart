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

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get passwordResetInstructions =>
      'Enter your email address. If an account exists, you will receive a link to reset your password.';

  @override
  String get sendResetEmail => 'Send reset link';

  @override
  String get passwordResetEmailSent =>
      'If an account exists for this email address, a reset link has been sent.';

  @override
  String get backToLogin => 'Back to login';

  @override
  String get enterValidEmail => 'Enter a valid email address.';

  @override
  String get enterPassword => 'Enter your password.';

  @override
  String get passwordMinimumLength => 'Use at least 6 characters.';

  @override
  String get enterPasswordConfirmation => 'Repeat your password.';

  @override
  String get verifyEmail => 'Verify your email address';

  @override
  String verificationEmailInstructions(String email) {
    return 'We sent a verification link to $email. Open the link and then return to the app.';
  }

  @override
  String get iHaveVerifiedEmail => 'I have verified my email';

  @override
  String get resendVerificationEmail => 'Resend verification email';

  @override
  String get verificationEmailResent =>
      'The verification email has been sent again.';

  @override
  String get emailNotVerifiedYet =>
      'Your email address has not been verified yet.';

  @override
  String get signInWithApple => 'Sign in with Apple';

  @override
  String get account => 'Account';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountWarning =>
      'Your account and profile will be permanently deleted. This action cannot be undone.';

  @override
  String get currentPassword => 'Current password';

  @override
  String get cancel => 'Cancel';

  @override
  String get deletePermanently => 'Delete permanently';

  @override
  String get authErrorInvalidEmail => 'The email address is invalid.';

  @override
  String get authErrorInvalidCredential =>
      'The email address or password is incorrect.';

  @override
  String get authErrorEmailAlreadyInUse =>
      'An account already exists for this email address.';

  @override
  String get authErrorWeakPassword => 'Choose a stronger password.';

  @override
  String get authErrorUserDisabled => 'This account has been disabled.';

  @override
  String get authErrorTooManyRequests => 'Too many attempts. Try again later.';

  @override
  String get authErrorNetwork =>
      'Check your internet connection and try again.';

  @override
  String get authErrorOperationNotAllowed =>
      'This sign-in method is not available yet.';

  @override
  String get authErrorRequiresRecentLogin =>
      'Sign in again to perform this sensitive action.';

  @override
  String get authErrorPasswordRequired => 'Enter your current password.';

  @override
  String get authErrorUnsupportedProvider =>
      'This account uses an unsupported sign-in method.';

  @override
  String get authErrorCancelled => 'Sign-in was cancelled.';

  @override
  String get authErrorUnknown => 'Authentication failed. Try again.';

  @override
  String get profileSyncFailed =>
      'You are signed in, but your profile could not be loaded. Please try again.';

  @override
  String get profileSyncPermissionDenied =>
      'You are signed in, but Firestore denied access to your profile. Check the deployed security rules.';

  @override
  String get profileSyncUnavailable =>
      'You are signed in, but profile storage is temporarily unavailable.';

  @override
  String get authErrorKeychain =>
      'Firebase cannot use the macOS keychain. Check Keychain Sharing and Apple code signing.';
}
