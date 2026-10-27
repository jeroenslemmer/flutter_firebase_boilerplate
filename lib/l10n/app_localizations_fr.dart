// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get login => 'Se connecter';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get createNewAccount => 'Créer un compte';

  @override
  String get signInWithGoogle => 'Se connecter avec Google';

  @override
  String get googleSignInPreparing =>
      'Préparation de la connexion avec Google…';

  @override
  String googleSignInUnavailable(String error) {
    return 'La connexion avec Google n’est pas disponible : $error';
  }

  @override
  String get register => 'S’inscrire';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get createAccount => 'Créer le compte';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas.';

  @override
  String errorWithDetails(String error) {
    return 'Une erreur s’est produite : $error';
  }

  @override
  String get home => 'Accueil';

  @override
  String get welcome => 'Bienvenue';

  @override
  String get noEmail => 'Aucune adresse e-mail';

  @override
  String get noName => 'Aucun nom';

  @override
  String get noUid => 'Aucun identifiant utilisateur';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get menu => 'Menu';

  @override
  String get profile => 'Profil';

  @override
  String get settings => 'Paramètres';

  @override
  String get noProfileFound => 'Aucun profil trouvé';

  @override
  String get appLanguage => 'Langue de l’application';

  @override
  String get dutch => 'Néerlandais';

  @override
  String get english => 'Anglais';

  @override
  String get french => 'Français';

  @override
  String get languageSaveFailed => 'La langue n’a pas pu être enregistrée.';

  @override
  String themeValue(String value) {
    return 'Thème : $value';
  }

  @override
  String profileCompleteValue(String value) {
    return 'Profil complet : $value';
  }

  @override
  String createdAtValue(String value) {
    return 'Créé : $value';
  }

  @override
  String lastLoginValue(String value) {
    return 'Dernière connexion : $value';
  }

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get notAvailable => 'Non disponible';

  @override
  String get theme => 'Thème';

  @override
  String get systemTheme => 'Système';

  @override
  String get lightTheme => 'Clair';

  @override
  String get darkTheme => 'Sombre';

  @override
  String versionValue(String value) {
    return 'Version : $value';
  }

  @override
  String branchValue(String value) {
    return 'Branche : $value';
  }

  @override
  String commitValue(String value) {
    return 'Commit : $value';
  }

  @override
  String builtValue(String value) {
    return 'Compilé : $value';
  }

  @override
  String platformValue(String value) {
    return 'Plateforme : $value';
  }

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get resetPassword => 'Réinitialiser le mot de passe';

  @override
  String get passwordResetInstructions =>
      'Saisissez votre adresse e-mail. Si un compte existe, vous recevrez un lien pour réinitialiser votre mot de passe.';

  @override
  String get sendResetEmail => 'Envoyer le lien de réinitialisation';

  @override
  String get passwordResetEmailSent =>
      'Si un compte existe pour cette adresse e-mail, un lien de réinitialisation a été envoyé.';

  @override
  String get backToLogin => 'Retour à la connexion';

  @override
  String get enterValidEmail => 'Saisissez une adresse e-mail valide.';

  @override
  String get enterPassword => 'Saisissez votre mot de passe.';

  @override
  String get passwordMinimumLength => 'Utilisez au moins 6 caractères.';

  @override
  String get enterPasswordConfirmation =>
      'Saisissez à nouveau votre mot de passe.';

  @override
  String get verifyEmail => 'Vérifiez votre adresse e-mail';

  @override
  String verificationEmailInstructions(String email) {
    return 'Nous avons envoyé un lien de vérification à $email. Ouvrez le lien, puis revenez dans l’application.';
  }

  @override
  String get iHaveVerifiedEmail => 'J’ai vérifié mon adresse e-mail';

  @override
  String get resendVerificationEmail => 'Renvoyer l’e-mail de vérification';

  @override
  String get verificationEmailResent =>
      'L’e-mail de vérification a été renvoyé.';

  @override
  String get emailNotVerifiedYet =>
      'Votre adresse e-mail n’a pas encore été vérifiée.';

  @override
  String get signInWithApple => 'Se connecter avec Apple';

  @override
  String get account => 'Compte';

  @override
  String get deleteAccount => 'Supprimer le compte';

  @override
  String get deleteAccountWarning =>
      'Votre compte et votre profil seront définitivement supprimés. Cette action est irréversible.';

  @override
  String get currentPassword => 'Mot de passe actuel';

  @override
  String get cancel => 'Annuler';

  @override
  String get deletePermanently => 'Supprimer définitivement';

  @override
  String get authErrorInvalidEmail => 'L’adresse e-mail n’est pas valide.';

  @override
  String get authErrorInvalidCredential =>
      'L’adresse e-mail ou le mot de passe est incorrect.';

  @override
  String get authErrorEmailAlreadyInUse =>
      'Un compte existe déjà pour cette adresse e-mail.';

  @override
  String get authErrorWeakPassword => 'Choisissez un mot de passe plus sûr.';

  @override
  String get authErrorUserDisabled => 'Ce compte a été désactivé.';

  @override
  String get authErrorTooManyRequests =>
      'Trop de tentatives. Réessayez plus tard.';

  @override
  String get authErrorNetwork =>
      'Vérifiez votre connexion Internet et réessayez.';

  @override
  String get authErrorOperationNotAllowed =>
      'Cette méthode de connexion n’est pas encore disponible.';

  @override
  String get authErrorRequiresRecentLogin =>
      'Reconnectez-vous pour effectuer cette action sensible.';

  @override
  String get authErrorPasswordRequired =>
      'Saisissez votre mot de passe actuel.';

  @override
  String get authErrorUnsupportedProvider =>
      'Ce compte utilise une méthode de connexion non prise en charge.';

  @override
  String get authErrorCancelled => 'La connexion a été annulée.';

  @override
  String get authErrorUnknown => 'L’authentification a échoué. Réessayez.';

  @override
  String get profileSyncFailed =>
      'Vous êtes connecté, mais votre profil n’a pas pu être chargé. Réessayez.';

  @override
  String get profileSyncPermissionDenied =>
      'Vous êtes connecté, mais Firestore a refusé l’accès à votre profil. Vérifiez les règles de sécurité déployées.';

  @override
  String get profileSyncUnavailable =>
      'Vous êtes connecté, mais le stockage du profil est temporairement indisponible.';

  @override
  String get authErrorKeychain =>
      'Firebase ne peut pas utiliser le trousseau macOS. Vérifiez le partage du trousseau et la signature Apple.';

  @override
  String get changePassword => 'Modifier le mot de passe';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get confirmNewPassword => 'Confirmer le nouveau mot de passe';

  @override
  String get savePassword => 'Enregistrer le mot de passe';

  @override
  String get passwordChanged => 'Votre mot de passe a été modifié.';

  @override
  String get chooseNewPassword => 'Choisissez un nouveau mot de passe';

  @override
  String get invalidPasswordResetLink =>
      'Ce lien de réinitialisation n’est pas valide ou a expiré. Demandez un nouveau lien depuis l’écran de connexion.';

  @override
  String get showPassword => 'Afficher le mot de passe';

  @override
  String get hidePassword => 'Masquer le mot de passe';

  @override
  String get emailAddressConfirmed =>
      'L’adresse e-mail a été confirmée. Revenez dans l’application et vérifiez votre validation ou reconnectez-vous.';

  @override
  String get emailAddressRestored =>
      'L’adresse e-mail d’origine a été restaurée. Reconnectez-vous et modifiez votre mot de passe si vous n’avez pas demandé ce changement.';

  @override
  String get invalidEmailActionLink =>
      'Ce lien est invalide ou a expiré. Demandez un nouvel e-mail dans l’application.';
}
