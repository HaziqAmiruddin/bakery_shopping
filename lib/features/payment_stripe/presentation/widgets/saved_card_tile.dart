import 'package:flutter/material.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/features/payment_stripe/domain/saved_card_entites.dart';

class SavedCardTile extends StatelessWidget {
  const SavedCardTile({super.key, required this.card, required this.onDelete});

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
