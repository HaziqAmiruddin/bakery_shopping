import 'package:flutter/material.dart';
import 'package:shopping_app/core/widgets/bordered_container.dart';

class StripeInfoCard extends StatelessWidget {
  const StripeInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const BorderedContainer(
      child: ListTile(
        leading: Icon(Icons.credit_card),
        title: Text('Pay with card via Stripe'),
        subtitle: Text('Use a saved card or enter a new one at checkout'),
      ),
    );
  }
}
