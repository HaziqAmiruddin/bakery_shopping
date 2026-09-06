import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final String id;
  final String label; // e.g. "Home", "Work"
  final String recipientName;
  final String phone;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String postcode;
  final bool isDefault;

  const Address({
    required this.id,
    required this.label,
    required this.recipientName,
    required this.phone,
    required this.addressLine1,
    this.addressLine2 = '',
    required this.city,
    required this.state,
    required this.postcode,
    this.isDefault = false,
  });

  Address copyWith({
    String? label,
    String? recipientName,
    String? phone,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? postcode,
    bool? isDefault,
  }) {
    return Address(
      id: id,
      label: label ?? this.label,
      recipientName: recipientName ?? this.recipientName,
      phone: phone ?? this.phone,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      state: state ?? this.state,
      postcode: postcode ?? this.postcode,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  factory Address.fromFirestore(String id, Map<String, dynamic> data) {
    return Address(
      id: id,
      label: data['label'] as String? ?? '',
      recipientName: data['recipientName'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      addressLine1: data['addressLine1'] as String? ?? '',
      addressLine2: data['addressLine2'] as String? ?? '',
      city: data['city'] as String? ?? '',
      state: data['state'] as String? ?? '',
      postcode: data['postcode'] as String? ?? '',
      isDefault: data['isDefault'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'label': label,
      'recipientName': recipientName,
      'phone': phone,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'postcode': postcode,
      'isDefault': isDefault,
    };
  }

  @override
  List<Object?> get props => [
    id,
    label,
    recipientName,
    phone,
    addressLine1,
    addressLine2,
    city,
    state,
    postcode,
    isDefault,
  ];
}
