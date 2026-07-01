import '../../core/firebase/auth_service.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {
  final AuthService authService = AuthService();
  HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: const Text('Home'),
        
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // logout komt hier
              authService.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Home (logged in) 🚀"),
            // Text(FirebaseAuth.instance.currentUser?.email ?? 'geen email')
          ],
        ),
      ),
    );
  }
}