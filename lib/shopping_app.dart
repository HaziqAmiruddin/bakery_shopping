import 'package:flutter/material.dart';
import 'package:shopping_app/core/theme/app_theme.dart';

class ShoppingApp extends StatelessWidget {
  const ShoppingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ShoppingBakeryApp",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      //themeMode: ThemeMode.system,
      //home: ,
    );
  }
}
