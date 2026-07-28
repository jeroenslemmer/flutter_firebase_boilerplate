import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../generated/build_info.dart';

class DebugInfo extends StatelessWidget {
  const DebugInfo({super.key});

  @override
  Widget build(BuildContext context) {
    if (kReleaseMode) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        '''
Version: ${BuildInfo.version}
Branch: ${BuildInfo.gitBranch}
Commit: ${BuildInfo.gitCommit}
Built: ${BuildInfo.buildDate}
Platform: ${Platform.operatingSystem}
''',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}