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

  Stream<List<CartItem>> watchCart() {
    return _cartRef.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => CartItem.fromFirestore(doc.data()))
          .toList(),
    );
  }

  Future<void> addToCart(Product product) async {
    final docRef = _cartRef.doc(product.id);
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
        ).toFirestore(),
      );
    }
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(productId);
      return;
    }
    await _cartRef.doc(productId).update({'quantity': quantity});
  }

  Future<void> removeFromCart(String productId) async {
    await _cartRef.doc(productId).delete();
  }
}
