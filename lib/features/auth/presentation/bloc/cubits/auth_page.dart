import 'package:flutter/material.dart';
import 'package:shopping_app/features/auth/presentation/pages/login_screen.dart';
import 'package:shopping_app/features/auth/presentation/pages/register_screen.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginScreen(togglePages: togglePages);
    } else {
      return RegisterScreen(togglePages: togglePages);
    }
  }
}
