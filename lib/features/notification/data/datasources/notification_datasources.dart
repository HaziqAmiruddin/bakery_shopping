import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopping_app/features/notification/data/models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<void> createLoginNotification();

  Stream<List<NotificationModel>> getNotifications();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  NotificationRemoteDataSourceImpl({
    required this.firestore,
    required this.firebaseAuth,
  });

  @override
  Future<void> createLoginNotification() async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('notifications')
        .add({
          'type': 'login',
          'title': 'Login Successful',
          'message': 'You logged in successfully.',
          'timestamp': FieldValue.serverTimestamp(),
          'isRead': false,
        });
  }

  @override
  Stream<List<NotificationModel>> getNotifications() {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    print('Reading notifications for UID: ${user.uid}');

    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          print('Number of notifications: ${snapshot.docs.length}');
          for (final doc in snapshot.docs) {
            print('Notification ID: ${doc.id}');
            print('Data: ${doc.data()}');
          }
          return snapshot.docs
              .map((doc) => NotificationModel.fromFirestore(doc))
              .toList();
        });
  }
}
