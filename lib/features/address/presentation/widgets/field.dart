import 'package:flutter/material.dart';
import 'package:shopping_app/core/theme/dimens.dart';

Widget field(
  TextEditingController controller,
  String hint, {
  TextInputType? keyboardType,
  bool required = true,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimens.corners),
      ),
    ),
    validator: required
        ? (value) => (value == null || value.trim().isEmpty) ? 'Required' : null
        : null,
  );
}
