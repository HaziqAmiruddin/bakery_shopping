import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shopping_app/core/gen/assets.gen.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/core/utils/app_navigator.dart';
import 'package:shopping_app/core/utils/check_device_size.dart';
import 'package:shopping_app/core/widgets/app_scaffold.dart';
import 'package:shopping_app/features/home/presentation/widgets/home_tab.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 5000), () {
      appPushReplacement(context, HomeTab());
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorsOwn = context.theme.appColors;
    return AppScaffold(
      backgroundColor: colorsOwn.brownExtraLight,
      padding: EdgeInsets.zero,
      safeAreaTop: false,
      body: Column(
        spacing: Dimens.largePadding,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Assets.images.splashHeader.image(),
          Assets.images.logo.image(
            width: checkVerySmallDeviceSize(context) ? 290 : 390,
          ),
          SizedBox(height: Dimens.largePadding),
          Assets.images.logo.image(
            width: checkSmallDeviceSize(context) ? 205 : 305,
          ),
        ],
      ),
    );
  }
}
