import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopping_app/features/cart/domain/entities/cart_item.dart';
import 'package:shopping_app/features/home/domain/entities/product_entities.dart';

class CartRemoteDataSource {
  CartRemoteDataSource({
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

  CollectionReference<Map<String, dynamic>> get _cartRef =>
      _firestore.collection('users').doc(_uid).collection('cart');

  // Stream<List<CartItem>> watchCart() {
  //   return _cartRef.snapshots().map(
  //     (snapshot) => snapshot.docs
  //         .map((doc) => CartItem.fromFirestore(doc.data()))
  //         .toList(),
  //   );
  // }

  Stream<List<CartItem>> watchCart() {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return Stream.value([]); // empty cart instead of crashing the stream
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CartItem.fromFirestore(doc.data()))
              .toList(),
        );
  }

  Future<void> addToCart(Product product, {String? weight}) async {
    final docId = weight != null && weight.isNotEmpty
        ? '${product.id}_$weight'
        : product.id;

    final docRef = _cartRef.doc(docId);
    final existing = await docRef.get();

    if (existing.exists) {
      await docRef.update({'quantity': FieldValue.increment(1)});
    } else {
      await docRef.set(
        CartItem(
          productId: product.id,
          name: product.name,
          image: product.image,
          price: product.discountedPrice,
          originalPrice: product.price,
          quantity: 1,
          weight: weight,
        ).toFirestore(),
      );
    }
  }

  Future<void> updateQuantity(String cartDocId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(cartDocId);
      return;
    }
    await _cartRef.doc(cartDocId).update({'quantity': quantity});
  }

  Future<void> removeFromCart(String cartDocId) async {
    await _cartRef.doc(cartDocId).delete();
  }

  Future<void> clearCart() async {
    final snapshot = await _cartRef.get();
    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
