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
import 'package:shopping_app/features/payment_stripe/domain/card_stripe_usecase.dart';
import 'package:shopping_app/features/payment_stripe/presentation/bloc/payment_event.dart';
import 'package:shopping_app/features/payment_stripe/presentation/bloc/payment_method_bloc.dart';
import 'package:shopping_app/features/payment_stripe/presentation/bloc/payment_method_state.dart';
import 'package:shopping_app/features/payment_stripe/presentation/widgets/saved_card_tile.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  bool _isAddingCard = false;

  Future<void> _addNewCard(BuildContext context, String uid) async {
    setState(() => _isAddingCard = true);

    try {
      final params = await getIt<CreatePaymentSheetParamsUseCase>()(uid);

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          setupIntentClientSecret: params['setupIntentClientSecret'] as String,
          customerEphemeralKeySecret: params['ephemeralKey'] as String,
          customerId: params['customerId'] as String,
          merchantDisplayName: 'Shopping Bakery App',
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Card added successfully')),
        );
        context.read<PaymentMethodBloc>().add(FetchSavedCards(uid));
      }
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) return;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add card: ${e.error.message}')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Something went wrong: $e')));
      }
    } finally {
      if (mounted) setState(() => _isAddingCard = false);
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
        appBar: null,
        body: Center(child: Text('Please log in to manage credit cards.')),
      );
    }

    return BlocProvider<PaymentMethodBloc>(
      create: (_) => getIt<PaymentMethodBloc>()..add(FetchSavedCards(uid)),
      child: AppScaffold(
        appBar: GeneralAppBar(title: 'Credit Cards List'),
        body: BlocBuilder<PaymentMethodBloc, PaymentMethodState>(
          builder: (context, state) {
            if (state is PaymentMethodLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PaymentMethodError) {
              return Center(child: Text(state.message));
            }

            if (state is PaymentMethodLoaded) {
              return Column(
                children: [
                  Expanded(
                    child: state.cards.isEmpty
                        ? Center(
                            child: Text(
                              'No saved cards yet',
                              style: appTypography.bodyLarge.copyWith(
                                color: appColors.gray4,
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: EdgeInsets.all(Dimens.largePadding),
                            itemCount: state.cards.length,
                            separatorBuilder: (_, __) =>
                                SizedBox(height: Dimens.padding),
                            itemBuilder: (context, index) {
                              final card = state.cards[index];
                              return SavedCardTile(
                                card: card,
                                onDelete: () {
                                  context.read<PaymentMethodBloc>().add(
                                    DeleteCardPressed(uid, card.id),
                                  );
                                },
                              );
                            },
                          ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(Dimens.largePadding),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: AppButton(
                        title: _isAddingCard ? 'Adding...' : 'Add New Card',
                        onPressed: _isAddingCard
                            ? null
                            : () => _addNewCard(context, uid),
                        margin: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
