import 'package:flutter/material.dart';
import 'package:shopping_app/core/gen/assets.gen.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/widgets/app_svg_viewer.dart';

class GoogleSignInButton extends StatelessWidget {
  final void Function()? onTap;
  const GoogleSignInButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorOwn = context.theme.appColors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorOwn.primary),
        ),
        child: AppSvgViewer(Assets.icons.googleLogo, height: 32),
      ),
    );
  }
}
