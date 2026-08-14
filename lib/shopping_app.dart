import 'package:flutter/material.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/features/auth/presentation/pages/login_screen.dart';
import 'package:shopping_app/features/splash/presentation/splash_screen.dart';

class ShoppingApp extends StatelessWidget {
  const ShoppingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ShoppingBakeryApp",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      //home: SplashScreen(),
      home: LoginScreen(),
    );
  }
}
