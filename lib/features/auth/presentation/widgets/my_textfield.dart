import 'package:flutter/material.dart';
import 'package:shopping_app/core/theme/app_theme.dart';

class MyTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const MyTextfield({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final colorOwn = context.theme.appColors;

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        // filled: true,
        // fillColor: colorOwn.white,
        //border unselect
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorOwn.primaryShade1),
          borderRadius: BorderRadius.circular(12),
        ),
        //border select
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorOwn.primary),
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: hintText,
      ),
    );
  }
}
