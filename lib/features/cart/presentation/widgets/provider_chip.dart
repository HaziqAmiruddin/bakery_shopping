import 'package:flutter/material.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/theme/dimens.dart';

class ProviderChip extends StatelessWidget {
  const ProviderChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final appColors = context.theme.appColors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimens.corners),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Dimens.padding),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? appColors.primary.withValues(alpha: 0.1) : null,
          border: Border.all(
            color: isSelected ? appColors.primary : appColors.gray4,
          ),
          borderRadius: BorderRadius.circular(Dimens.corners),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? appColors.primary : null,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
