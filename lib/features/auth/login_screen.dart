import 'package:flutter/material.dart';
import 'auth_controller.dart';

const gapS = SizedBox(height: 8);
const gapM = SizedBox(height: 16);
const gapL = SizedBox(height: 24);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthController _authController = AuthController();

  bool _loading = false;

  Future<void> _login() async {
    setState(() => _loading = true);

    try {
      await _authController.signIn(
        _emailController.text,
        _passwordController.text,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }

    setState(() => _loading = false);
  }
  Future<void> _loginWithGoogle() async {
  setState(() => _loading = true);

  try {
    await _authController.signInWithGoogle();
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  if (mounted) {
    setState(() => _loading = false);
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
                    onPressed: _login,
                    child: const Text("Login"),
                  ),
                  
            gapS,

            ElevatedButton(
              onPressed: _loginWithGoogle,
              child: const Text("Sign in with Google"),
            ),
                            ],
        ),
      ),
    );
  }
}