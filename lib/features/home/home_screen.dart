import 'package:flutter/material.dart';
import '../../core/widgets/debug_info.dart';  
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/auth_provider.dart';


class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref){
    return Scaffold(
      
      appBar: AppBar(
        title: const Text('Home'),
        
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authControllerProvider).signOut();
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
                const Spacer(),
                const DebugInfo(),
          ],
        ),
      ),
    );
  }
}