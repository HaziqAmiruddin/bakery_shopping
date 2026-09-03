import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shopping_app/core/inject/injection.dart';
import 'package:shopping_app/features/profile/data/payment_method_api_service.dart';

Future<void> addNewCard(BuildContext context, String uid) async {
  final apiService = getIt<PaymentMethodApiService>();

  try {
    final params = await apiService.createPaymentSheetParams(uid);

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        setupIntentClientSecret: params['setupIntentClientSecret'] as String,
        customerEphemeralKeySecret: params['ephemeralKey'] as String,
        customerId: params['customerId'] as String,
        merchantDisplayName: 'Shopping Bakery App',
      ),
    );

    await Stripe.instance.presentPaymentSheet();

    // Card saved successfully on Stripe's side — refresh the list.
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Card added successfully')));
    }
  } on StripeException catch (e) {
    if (e.error.code == FailureCode.Canceled)
      return; // user backed out, not an error
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add card: ${e.error.message}')),
      );
    }
  }
}
