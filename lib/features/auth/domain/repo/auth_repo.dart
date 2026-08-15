import 'package:shopping_app/features/auth/domain/entities/app_user.dart';

abstract class AuthRepo {
  //log in with email
  Future<AppUser?> loginWithEmailPassword(String email, String password);
  Future<AppUser?> registerWithEmailPassword(
    String name,
    String email,
    String password,
  );
  Future<void> logout();
  Future<AppUser?> getCurrentUser();
  Future<String> sendPasswordResetEmail(String email);
  Future<void> deleteAccount();

  //log in with google
  Future<AppUser?> signInWithGoogle();

  //log in with Apple
  // Future<AppUser?> signInWithApple();
}
