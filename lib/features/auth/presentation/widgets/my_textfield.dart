import 'package:flutter/material.dart';
import 'package:shopping_app/core/theme/app_theme.dart';

class MyTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;

  const MyTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final colorOwn = context.theme.appColors;

    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
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
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorOwn.error),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorOwn.error),
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: hintText,
      ),
    );
  }
}
