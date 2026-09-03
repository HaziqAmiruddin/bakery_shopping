import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shopping_app/core/inject/injection.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/core/widgets/app_button.dart';
import 'package:shopping_app/core/widgets/app_scaffold.dart';
import 'package:shopping_app/core/widgets/bordered_container.dart';
import 'package:shopping_app/core/widgets/general_app_bar.dart';
import 'package:shopping_app/features/auth/presentation/bloc/cubits/auth_cubit.dart';
import 'package:shopping_app/features/profile/domain/create_payment_sheet_param_usecase.dart';
import 'package:shopping_app/features/profile/domain/saved_card_entites.dart';
import 'package:shopping_app/features/profile/presentation/bloc/payment_event.dart';
import 'package:shopping_app/features/profile/presentation/bloc/payment_method_bloc.dart';
import 'package:shopping_app/features/profile/presentation/bloc/payment_method_state.dart';

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
                              return _SavedCardTile(
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

class _SavedCardTile extends StatelessWidget {
  const _SavedCardTile({required this.card, required this.onDelete});

  final SavedCard card;
  final VoidCallback onDelete;

  List<Color> get _brandGradient {
    switch (card.brand.toLowerCase()) {
      case 'visa':
        return [const Color(0xFF1A1F71), const Color(0xFF3B4CCA)];
      case 'mastercard':
        return [const Color(0xFF232526), const Color(0xFF414345)];
      default:
        return [const Color(0xFF2C3E50), const Color(0xFF4CA1AF)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(card.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        return await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete card?'),
                content: Text(
                  'Remove ${card.brand.toUpperCase()} •••• ${card.last4}?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ) ??
            false;
      },
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: Dimens.largePadding),
        margin: EdgeInsets.only(bottom: Dimens.padding),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(Dimens.corners),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: Dimens.padding),
        padding: EdgeInsets.all(Dimens.largePadding),
        height: 190,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimens.corners),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _brandGradient,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.sim_card, color: Colors.white70, size: 32),
                Text(
                  card.brand.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              '•••• •••• •••• ${card.last4}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                letterSpacing: 3,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: Dimens.padding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'EXPIRES',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 10,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  '${card.expMonth.toString().padLeft(2, '0')}/${card.expYear.toString().substring(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
