import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shopping_app/features/auth/domain/entities/app_user.dart';
import 'package:shopping_app/features/auth/domain/repo/auth_repo.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

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

    return AppUser(uid: fireBaseUser.uid, email: fireBaseUser.email!);
  }

  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      AppUser user = AppUser(uid: userCredential.user!.uid, email: email);

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

      AppUser user = AppUser(uid: userCredential.user!.uid, email: email);

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

      AppUser appUser = AppUser(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? "",
      );

      return appUser;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // @override
  // Future<AppUser?> signInWithApple() async {
  //   try {
  //     // request Apple ID credentials
  //     final appleCredential =
  //         await SignInWithApple.getAppleIDCredential(scopes: [
  //       AppleIDAuthorizationScopes.email,
  //       AppleIDAuthorizationScopes.fullName,
  //     ]);

  //     // create an OAuth credential
  //     final oAuthCredential = OAuthProvider("apple.com").credential(
  //       idToken: appleCredential.identityToken,
  //       accessToken: appleCredential.authorizationCode,
  //     );

  //     // sign in with the credential
  //     UserCredential userCredential =
  //         await firebaseAuth.signInWithCredential(oAuthCredential);

  //     // firebase user
  //     final firebaseUser = userCredential.user;

  //     // user cancelled the sign-in process
  //     if (firebaseUser == null) return null;

  //     AppUser appUser = AppUser(
  //       uid: firebaseUser.uid,
  //       email: firebaseUser.email ?? '',
  //     );

  //     return appUser;
  //   } catch (e) {
  //     print("Error signing in with apple: $e");
  //     return null;
  //   }

  // }
}
