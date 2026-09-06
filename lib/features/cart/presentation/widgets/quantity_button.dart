import 'package:flutter/material.dart';
import 'package:shopping_app/core/theme/app_theme.dart';

class QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const QuantityButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: context.theme.appColors.gray4),
        ),
        child: Icon(icon, size: 14),
      ),
    );
  }
}
