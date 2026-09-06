import 'package:flutter/material.dart';
import 'package:shopping_app/core/widgets/bordered_container.dart';

class XenditInfoCard extends StatelessWidget {
  const XenditInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const BorderedContainer(
      child: ListTile(
        leading: Icon(Icons.account_balance_outlined),
        title: Text('Card or FPX via Xendit'),
        subtitle: Text(
          'You\'ll choose your exact payment method on the next screen',
        ),
      ),
    );
  }
}
