import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shopping_app/features/auth/domain/entities/app_user.dart';
import 'package:shopping_app/features/auth/domain/repo/auth_repo.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<void> deleteAccount() async {
    try {
      final user = firebaseAuth.currentUser;

      if (user == null) throw Exception('No User Logged In..');

      await user.delete();

      await logout();
    } catch (e) {
      throw Exception('Failed To Delete Accounnt: $e');
    }
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final fireBaseUser = firebaseAuth.currentUser;

    if (fireBaseUser == null) return null;

    return AppUser(
      uid: fireBaseUser.uid,
      email: fireBaseUser.email!,
      name: fireBaseUser.displayName ?? '',
    );
  }

  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      final userRef = firebaseFirestore
          .collection('users')
          .doc(userCredential.user!.uid);

      await userRef.collection('notifications').add({
        'type': 'login',
        'title': 'Login Successful',
        'message': 'You logged in successfully.',
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });

      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        name: '',
      );

      return user;
    } catch (e) {
      throw Exception('login failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<AppUser?> registerWithEmailPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        name: name,
      );

      await firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .set(user.toJson());

      return user;
    } catch (e) {
      throw Exception('Register failed: $e');
    }
  }

  @override
  Future<String> sendPasswordResetEmail(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return "Password reset email! Check Inbox";
    } catch (e) {
      return "An Error Occured: $e";
    }
  }

  @override
  Future<AppUser?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      if (gUser == null) return null;

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      UserCredential userCredential = await firebaseAuth.signInWithCredential(
        credential,
      );

      final firebaseUser = userCredential.user;

      if (firebaseUser == null) return null;

      final uid = firebaseUser.uid;

      final userRef = firebaseFirestore.collection('users').doc(uid);

      final userSnapshot = await userRef.get();

      if (!userSnapshot.exists) {
        await userRef.set({
          'uid': uid,
          'email': firebaseUser.email ?? '',
          'name': firebaseUser.displayName ?? '',
          'photoUrl': firebaseUser.photoURL ?? '',
          'provider': 'google',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      await userRef.collection('notifications').add({
        'type': 'login',
        'title': 'Login Successful',
        'message': 'You logged in successfully.',
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });

      AppUser appUser = AppUser(
        uid: uid,
        email: firebaseUser.email ?? "",
        name: firebaseUser.displayName ?? "",
      );

      return appUser;
    } catch (e) {
      print('Google Sign In Error: $e');
      return null;
    }
  }
}
