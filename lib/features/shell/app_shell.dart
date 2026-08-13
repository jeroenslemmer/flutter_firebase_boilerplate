import 'package:flutter/material.dart';

import '../home/home_screen.dart';
import '../profile/profile_screen.dart';
import '../settings/settings_screen.dart';
import '../../l10n/app_localizations.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(
              tooltip: l10n.home,
              icon: Icon(
                Icons.home,
                color: _index == 0
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              onPressed: () => setState(() => _index = 0),
            ),
            const Spacer(),
            PopupMenuButton<_MenuDestination>(
              tooltip: l10n.menu,
              icon: const Icon(Icons.menu),
              onSelected: (destination) {
                setState(() {
                  _index = switch (destination) {
                    _MenuDestination.profile => 1,
                    _MenuDestination.settings => 2,
                  };
                });
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: _MenuDestination.profile,
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(l10n.profile),
                  ),
                ),
                PopupMenuItem(
                  value: _MenuDestination.settings,
                  child: ListTile(
                    leading: const Icon(Icons.settings),
                    title: Text(l10n.settings),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum _MenuDestination { profile, settings }
