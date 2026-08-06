import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_controller.dart';
import 'auth_provider.dart';
import 'register_screen.dart';
import 'widgets/google_sign_in_button.dart';

const gapS = SizedBox(height: 8);
const gapM = SizedBox(height: 16);
const gapL = SizedBox(height: 24);

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

@override
ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

AuthController get _authController =>
    ref.read(authControllerProvider);

  bool _loading = false;

  Future<void> _login() async {
    setState(() => _loading = true);
    try {
      await _authController.signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Login", style: TextStyle(fontSize: 24)),

            gapL,

            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),

            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),

            gapL,

            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _loading ? null : _login,
                    child: const Text("Login"),
                  ),
                  
            gapS,

            const GoogleSignInButton(),

            gapL,
            const SizedBox(height: 8),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegisterScreen(),
                  ),
                );
              },
              child: const Text('Create a new account'),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}