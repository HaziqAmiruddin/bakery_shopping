import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopping_app/features/address/domain/address_entities.dart';

class AddressRemoteDataSource {
  AddressRemoteDataSource({
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseAuth,
  }) : _firestore = firestore,
       _firebaseAuth = firebaseAuth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  String get _uid {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) throw Exception('User not authenticated');
    return uid;
  }

  CollectionReference<Map<String, dynamic>> get _addressesRef =>
      _firestore.collection('users').doc(_uid).collection('addresses');

  Stream<List<Address>> watchAddresses() {
    return _addressesRef.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => Address.fromFirestore(doc.id, doc.data()))
          .toList(),
    );
  }

  Future<void> addAddress(Address address) async {
    final docRef = _addressesRef.doc();

    // If this is the first address, make it default automatically.
    final existing = await _addressesRef.limit(1).get();
    final shouldBeDefault = address.isDefault || existing.docs.isEmpty;

    if (shouldBeDefault) {
      await _clearExistingDefaults();
    }

    await docRef.set(
      address.copyWith(isDefault: shouldBeDefault).toFirestore(),
    );
  }

  Future<void> updateAddress(Address address) async {
    if (address.isDefault) {
      await _clearExistingDefaults();
    }
    await _addressesRef.doc(address.id).update(address.toFirestore());
  }

  Future<void> deleteAddress(String addressId) async {
    await _addressesRef.doc(addressId).delete();
  }

  Future<void> setDefaultAddress(String addressId) async {
    await _clearExistingDefaults();
    await _addressesRef.doc(addressId).update({'isDefault': true});
  }

  Future<void> _clearExistingDefaults() async {
    final snapshot = await _addressesRef
        .where('isDefault', isEqualTo: true)
        .get();

    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {'isDefault': false});
    }
    await batch.commit();
  }
}
