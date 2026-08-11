import 'package:flutter/material.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/core/widgets/app_svg_viewer.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    this.title,
    this.child,
    required this.onPressed,
    this.textStyle,
    this.margin,
    this.color,
    this.iconPath,
  });

  final String? title;
  final Widget? child;
  final TextStyle? textStyle;
  final GestureTapCallback? onPressed;
  final EdgeInsets? margin;
  final Color? color;
  final String? iconPath;

  @override
  Widget build(final BuildContext context) {
    final primaryColor = context.theme.appColors.primary;
    return Container(
      height: 40.0,
      margin: margin ?? const EdgeInsets.symmetric(vertical: Dimens.padding),
      child: TextButton(
        onPressed: onPressed,
        child:
            child ??
            Row(
              spacing: Dimens.smallPadding,
              children: [
                Text(
                  title ?? '',
                  style: textStyle ?? TextStyle(color: color ?? primaryColor),
                ),
                if (iconPath != null)
                  AppSvgViewer(iconPath!, color: primaryColor, width: 16),
              ],
            ),
      ),
    );
  }
}
