# Conceptantwoord voor Firebase Support — case 10433272

De handler is op 27 oktober 2026 gedeployed en bereikbaarheid is in de browser
gecontroleerd. De huidige Action URL en Authorized domains zijn op dezelfde dag
live gecontroleerd in de Firebase Console. Het antwoord hieronder is klaar om
te versturen; er is nog niets verzonden.

```text
Hello Marco,

We would like to proceed with option 1, for the shared Action URL only.
Please keep the existing email subjects and HTML templates unchanged.

Project ID: base-app-f5a6e
Current Action URL: https://base-app-f5a6e.firebaseapp.com/__/auth/action
Requested Action URL: https://base-app-f5a6e.web.app/auth/action

- The handler is deployed and reachable at the exact requested URL.
- base-app-f5a6e.web.app is listed under Authorized Domains.

The handler supports resetPassword, verifyEmail, recoverEmail and
verifyAndChangeEmail. We do not use email-link sign-in. Unknown modes and
invalid or expired codes show an error. The handler uses the project's own
Firebase SDK configuration and does not automatically redirect to continueUrl.
Email actions are handled in a browser for our web, macOS, iOS and Android apps.

I explicitly authorize Firebase Support to submit this Action URL change for
internal review and, if approved, apply it to the project.

Please confirm whether any additional information is required when only the
Action URL is changing and the existing email content is retained.

Best regards,
Jeroen
```
