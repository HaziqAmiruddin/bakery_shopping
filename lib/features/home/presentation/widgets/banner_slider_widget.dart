import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/core/utils/check_device_size.dart';
import 'package:shopping_app/core/utils/sized_context.dart';
import 'package:shopping_app/features/home/data/product_data/local_data.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerSliderWidget extends StatefulWidget {
  const BannerSliderWidget({super.key});

  @override
  State<BannerSliderWidget> createState() => _BannerSliderWidgetState();
}

class _BannerSliderWidgetState extends State<BannerSliderWidget> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorsOwn = context.theme.appColors;
    return Center(
      child: SizedBox(
        width: checkDesktopSize(context)
            ? Dimens.largeDeviceBreakPoint
            : context.widthPx,
        child: Column(
          spacing: Dimens.padding,
          children: [
            CarouselSlider(
              items: banners.map((banner) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.largePadding,
                  ),
                  child: Image.asset(banner),
                );
              }).toList(),
              options: CarouselOptions(
                autoPlay: false,
                enlargeCenterPage: true,
                enlargeFactor: 0.5,
                aspectRatio: 2.3,
                viewportFraction: 1,
                onPageChanged: (final index, final reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
            AnimatedSmoothIndicator(
              activeIndex: _currentIndex,
              count: banners.length,
              effect: WormEffect(
                activeDotColor: colorsOwn.primary,
                dotColor: colorsOwn.gray,
                dotHeight: 8,
                dotWidth: 8,
                spacing: 4,
                type: WormType.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
