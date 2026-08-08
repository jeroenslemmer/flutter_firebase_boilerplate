import 'package:flutter/widgets.dart';

/// Native fallback. This is never displayed because the caller checks kIsWeb.
Widget buildGoogleSignInWebButton() => const SizedBox.shrink();
