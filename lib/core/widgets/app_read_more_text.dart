import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:shopping_app/core/theme/app_theme.dart';

class AppReadMoreText extends StatelessWidget {
  const AppReadMoreText(
    this.text, {
    super.key,
    this.textAlign,
    this.style,
    this.trimLines,
  });

  final String? text;
  final TextAlign? textAlign;
  final TextStyle? style;
  final int? trimLines;

  @override
  Widget build(final BuildContext context) {
    final primaryColor = context.theme.appColors.primary;
    return ReadMoreText(
      text ?? '',
      textAlign: textAlign ?? TextAlign.justify,
      trimLines: trimLines ?? 5,
      trimMode: TrimMode.Line,
      trimCollapsedText: ' Read more',
      trimExpandedText: ' Read less',
      moreStyle: TextStyle(color: primaryColor),
      lessStyle: TextStyle(color: primaryColor),
    );
  }
}
