import 'package:flutter/material.dart';
import 'package:shopping_app/core/gen/assets.gen.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/widgets/app_scaffold.dart';
import 'package:shopping_app/core/widgets/app_svg_viewer.dart';
import 'package:shopping_app/features/cart/presentation/pages/cart_screen.dart';
import 'package:shopping_app/features/home/presentation/pages/home_screen.dart';
import 'package:shopping_app/features/home/presentation/widgets/home_app_bar.dart';
import 'package:shopping_app/features/map/presentation/pages/map_screen.dart';
import 'package:shopping_app/features/order/presentation/pages/order_screen.dart';
import 'package:shopping_app/features/profile/presentation/pages/profile_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final List<Widget> tab = [
      const HomeScreen(),
      const CartScreen(),
      const OrderScreen(),
      const MapScreen(),
      const ProfileScreen(),
    ];

    final colorsOwn = context.theme.appColors;
    return AppScaffold(
      appBar: currentIndex == 0 ? HomeAppBar() : null,
      body: tab[currentIndex],
      padding: EdgeInsets.zero,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.only(top: 8, right: 8, left: 8),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
          destinations: [
            NavigationDestination(
              icon: AppSvgViewer(Assets.icons.home2, color: colorsOwn.primary),
              label: "Home",
            ),
            NavigationDestination(
              icon: AppSvgViewer(
                Assets.icons.shoppingCart,
                color: colorsOwn.primary,
              ),
              label: "Cart",
            ),
            NavigationDestination(
              icon: AppSvgViewer(
                Assets.icons.receipt,
                color: colorsOwn.primary,
              ),
              label: "Order",
            ),
            NavigationDestination(
              icon: AppSvgViewer(Assets.icons.map1, color: colorsOwn.primary),
              label: "Map",
            ),
            NavigationDestination(
              icon: AppSvgViewer(Assets.icons.user, color: colorsOwn.primary),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
