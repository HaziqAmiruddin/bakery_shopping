import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopping_app/features/home/domain/entities/fav_item_entities.dart';
import 'package:shopping_app/features/home/domain/entities/product_entities.dart';

class FavoriteRemoteDataSource {
  FavoriteRemoteDataSource({
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

  CollectionReference<Map<String, dynamic>> get _favoritesRef =>
      _firestore.collection('users').doc(_uid).collection('favorites');

  Stream<List<FavoriteItem>> watchFavorites() {
    return _favoritesRef.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => FavoriteItem.fromFirestore(doc.data()))
          .toList(),
    );
  }

  Future<void> toggleFavorite(Product product) async {
    final docRef = _favoritesRef.doc(product.id);
    final existing = await docRef.get();

    if (existing.exists) {
      await docRef.delete();
    } else {
      await docRef.set(
        FavoriteItem(
          productId: product.id,
          name: product.name,
          image: product.image,
          price: product.discountedPrice,
          isRemote: product.source == ProductSource.remote,
        ).toFirestore(),
      );
    }
  }
}
