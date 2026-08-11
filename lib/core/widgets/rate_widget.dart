import 'package:flutter/material.dart';
import 'package:shopping_app/core/gen/assets.gen.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/core/widgets/app_svg_viewer.dart';

class RateWidget extends StatelessWidget {
  const RateWidget({super.key, required this.rate, this.textColor});

  final String rate;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: Dimens.smallPadding,
      children: [
        AppSvgViewer(
          Assets.icons.starFilled,
          color: context.theme.appColors.primary,
          width: 16,
        ),
        Text(rate, style: TextStyle(color: textColor, fontSize: 12)),
      ],
    );
  }
}
