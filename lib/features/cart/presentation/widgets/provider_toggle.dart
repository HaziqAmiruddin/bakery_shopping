import 'package:flutter/material.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/features/cart/presentation/pages/checkout_screen.dart';
import 'package:shopping_app/features/cart/presentation/widgets/provider_chip.dart';

class ProviderToggle extends StatelessWidget {
  const ProviderToggle({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final PaymentProvider selected;
  final ValueChanged<PaymentProvider> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: Dimens.padding,
      children: [
        Expanded(
          child: ProviderChip(
            label: 'Stripe (Card)',
            isSelected: selected == PaymentProvider.stripe,
            onTap: () => onChanged(PaymentProvider.stripe),
          ),
        ),
        Expanded(
          child: ProviderChip(
            label: 'Xendit (Card/FPX)',
            isSelected: selected == PaymentProvider.xendit,
            onTap: () => onChanged(PaymentProvider.xendit),
          ),
        ),
      ],
    );
  }
}
