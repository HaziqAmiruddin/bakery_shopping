import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shopping_app/core/inject/injection.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/core/widgets/app_button.dart';
import 'package:shopping_app/core/widgets/app_scaffold.dart';
import 'package:shopping_app/core/widgets/general_app_bar.dart';
import 'package:shopping_app/features/auth/presentation/bloc/cubits/auth_cubit.dart';
import 'package:shopping_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:shopping_app/features/cart/presentation/bloc/cart_event.dart';
import 'package:shopping_app/features/cart/presentation/bloc/cart_state.dart';
import 'package:shopping_app/features/cart/presentation/widgets/delivery_address_section.dart';
import 'package:shopping_app/features/cart/presentation/widgets/provider_toggle.dart';
import 'package:shopping_app/features/cart/presentation/widgets/stripe_info_card.dart';
import 'package:shopping_app/features/cart/presentation/widgets/xendit_info_card.dart';
import 'package:shopping_app/features/order/presentation/pages/order_screen.dart';
import 'package:shopping_app/features/payment_stripe/data/payment_method_api_service.dart';
import 'package:shopping_app/features/payment_xendit/data/xendit_api_service.dart';
import 'package:shopping_app/features/payment_xendit/presentation/pages/xendit_payment_screen.dart';

enum PaymentProvider { stripe, xendit }

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  PaymentProvider _selectedProvider = PaymentProvider.stripe;
  bool _isProcessing = false;

  Future<void> _payWithXendit(
    BuildContext context,
    String uid,
    double amount,
  ) async {
    setState(() => _isProcessing = true);

    try {
      final authCubit = context.read<AuthCubit>();
      final email = authCubit.currentUser?.email ?? 'guest@example.com';

      final result = await getIt<XenditApiService>().createInvoice(
        uid: uid,
        amount: amount,
        email: email,
      );

      if (!context.mounted) return;

      final paymentSucceeded = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) =>
              XenditPaymentScreen(invoiceUrl: result['invoiceUrl'] as String),
        ),
      );

      if (paymentSucceeded == true && context.mounted) {
        context.read<CartBloc>().add(CartCleared());

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Payment successful!')));

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const OrderScreen()),
          (route) => route.isFirst,
        );
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment was not completed')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Something went wrong: $e')));
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _payWithStripe(
    BuildContext context,
    String uid,
    double amount,
  ) async {
    setState(() => _isProcessing = true);

    try {
      final params = await getIt<PaymentMethodApiService>().createPaymentIntent(
        uid: uid,
        amount: amount,
      );

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret:
              params['paymentIntentClientSecret'] as String,
          customerEphemeralKeySecret: params['ephemeralKey'] as String,
          customerId: params['customerId'] as String,
          merchantDisplayName: 'Shopping Bakery App',
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      // Payment succeeded — proceed to order creation (next feature).
      if (context.mounted) {
        context.read<CartBloc>().add(CartCleared());

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Payment successful!')));
        // TODO: create order in Firestore, clear cart, navigate to order confirmation

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const OrderScreen()),
          (route) => route.isFirst, // clears checkout/cart from the back stack
        );
      }
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) return;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: ${e.error.message}')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Something went wrong: $e')));
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final uid = authCubit.currentUser?.uid;
    final appColors = context.theme.appColors;
    final appTypography = context.theme.appTypography;

    if (uid == null) {
      return const AppScaffold(
        body: Center(child: Text('Please log in to checkout.')),
      );
    }

    return AppScaffold(
      appBar: GeneralAppBar(title: 'Checkout'),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, cartState) {
          if (cartState is! CartLoaded || cartState.items.isEmpty) {
            return const Center(child: Text('Your cart is empty.'));
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(Dimens.largePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Dimens.largePadding,
              children: [
                Text(
                  'Delivery Address',
                  style: appTypography.bodyLarge.copyWith(fontSize: 18),
                ),
                const DeliveryAddressSection(),

                Text(
                  'Payment Method',
                  style: appTypography.bodyLarge.copyWith(fontSize: 18),
                ),
                ProviderToggle(
                  selected: _selectedProvider,
                  onChanged: (provider) =>
                      setState(() => _selectedProvider = provider),
                ),

                if (_selectedProvider == PaymentProvider.stripe)
                  const StripeInfoCard()
                else
                  const XenditInfoCard(), // stub until Xendit is ready

                Divider(height: Dimens.largePadding),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total', style: appTypography.bodyLarge),
                    Text(
                      '\$ ${cartState.total.toStringAsFixed(2)}',
                      style: appTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: AppButton(
                    title: _isProcessing ? 'Processing...' : 'Pay Now',
                    onPressed: _isProcessing
                        ? null
                        : () {
                            if (_selectedProvider == PaymentProvider.stripe) {
                              _payWithStripe(context, uid, cartState.total);
                            } else {
                              _payWithXendit(context, uid, cartState.total);
                            }
                          },
                    margin: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
