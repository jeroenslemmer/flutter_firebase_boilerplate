import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../generated/build_info.dart';
import '../../l10n/app_localizations.dart';

class DebugInfo extends StatelessWidget {
  const DebugInfo({super.key});

  String get platform {
    if (kIsWeb) {
      return 'web';
    }

    return defaultTargetPlatform.name;
  }

  @override
  Widget build(BuildContext context) {
    if (kReleaseMode) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        [
          l10n.versionValue(BuildInfo.version),
          l10n.branchValue(BuildInfo.gitBranch),
          l10n.commitValue(BuildInfo.gitCommit),
          l10n.builtValue(BuildInfo.buildDate),
          l10n.platformValue(platform),
        ].join('\n'),
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
