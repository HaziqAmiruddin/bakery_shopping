import 'package:flutter/material.dart';
import 'package:shopping_app/core/gen/assets.gen.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/widgets/app_svg_viewer.dart';

class PasswordTextfield extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final String? Function(String?)? validator;

  const PasswordTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
  });

  @override
  State<PasswordTextfield> createState() => _PasswordTextfieldState();
}

class _PasswordTextfieldState extends State<PasswordTextfield> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final colorOwn = context.theme.appColors;
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      validator: widget.validator,
      decoration: InputDecoration(
        hintText: widget.hintText,
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
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscure = !_obscure;
            });
          },
          icon: _obscure
              ? AppSvgViewer(Assets.icons.starSlash)
              : AppSvgViewer(Assets.icons.star),
        ),
      ),
    );
  }
}
