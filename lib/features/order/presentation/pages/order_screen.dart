import 'package:flutter/material.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/utils/check_theme_status.dart';
import 'package:shopping_app/core/widgets/app_scaffold.dart';
import 'package:shopping_app/core/widgets/general_app_bar.dart';
import 'package:shopping_app/features/order/presentation/widgets/order_list_widget.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.theme.appColors;
    return AppScaffold(
      appBar: GeneralAppBar(
        title: 'My Orders',
        showBackIcon: false,
        height: AppBar().preferredSize.height + 56,
        bottom: TabBar(
          controller: _tabController,
          dividerColor: appColors.gray,
          labelColor: appColors.primary,
          labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          unselectedLabelColor: checkDarkMode(context)
              ? appColors.white
              : appColors.black,
          indicatorColor: appColors.primary,
          tabs: [
            Tab(child: Text('Active')),
            Tab(child: Text('Completed')),
            Tab(child: Text('Cancelled')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          OrdersListWidget(orderType: OrderType.active),
          OrdersListWidget(orderType: OrderType.completed),
          OrdersListWidget(orderType: OrderType.canceled),
        ],
      ),
    );
  }
}
