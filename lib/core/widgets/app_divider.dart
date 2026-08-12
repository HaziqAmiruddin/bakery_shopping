import 'package:flutter/material.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/utils/check_theme_status.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({
    super.key,
    this.height,
    this.thickness,
    this.indent,
    this.endIndent,
  });

  final double? height;
  final double? thickness;
  final double? indent;
  final double? endIndent;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height ?? 0,
      color: checkDarkMode(context)
          ? context.theme.appColors.gray4.withValues(alpha: 0.3)
          : context.theme.appColors.gray,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
    );
  }
}
