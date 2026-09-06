import 'package:equatable/equatable.dart';

class SavedCard extends Equatable {
  final String id;
  final String brand;
  final String last4;
  final int expMonth;
  final int expYear;

  const SavedCard({
    required this.id,
    required this.brand,
    required this.last4,
    required this.expMonth,
    required this.expYear,
  });

  factory SavedCard.fromJson(Map<String, dynamic> json) {
    return SavedCard(
      id: json['id'] as String,
      brand: json['brand'] as String,
      last4: json['last4'] as String,
      expMonth: json['expMonth'] as int,
      expYear: json['expYear'] as int,
    );
  }

  @override
  List<Object?> get props => [id, brand, last4, expMonth, expYear];
}
