import 'package:flutter/material.dart';

import '../home/home_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {

  int _index = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    const Placeholder(),
    const Placeholder(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _pages[_index],

      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,

        onDestinationSelected: (index) {
          setState(() {
            _index = index;
          });
        },

        destinations: const [

          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),

          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),

          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),

        ],
      ),
    );
  }
}