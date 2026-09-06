import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/core/inject/injection.dart';
import 'package:shopping_app/features/auth/domain/entities/app_user.dart';
import 'package:shopping_app/features/auth/domain/repo/auth_repo.dart';
import 'package:shopping_app/features/auth/presentation/bloc/cubits/auth_state.dart';
import 'package:shopping_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:shopping_app/features/cart/presentation/bloc/cart_event.dart';
import 'package:shopping_app/features/home/presentation/bloc/bloc/fav_bloc.dart';
import 'package:shopping_app/features/home/presentation/bloc/event/fav_event.dart';
import 'package:shopping_app/features/address/presentation/bloc/address_bloc.dart';
import 'package:shopping_app/features/address/presentation/bloc/address_event.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  AuthCubit({required this.authRepo}) : super(AuthInitial());

  AppUser? _currentUser;

  AppUser? get currentUser => _currentUser;

  void checkAuth() async {
    emit(AuthLoading());

    final AppUser? user = await authRepo.getCurrentUser();

    if (user != null) {
      _currentUser = user;
      emit(Authenticated(user));
      _startUserDataStreams();
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> login(String email, String pw) async {
    try {
      emit(AuthLoading());

      final user = await authRepo.loginWithEmailPassword(email, pw);

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
        _startUserDataStreams();
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  Future<void> register(String name, String email, String pw) async {
    try {
      emit(AuthLoading());

      final user = await authRepo.registerWithEmailPassword(name, email, pw);

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
        _startUserDataStreams();
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    await authRepo.logout();
    emit(Unauthenticated());
  }

  Future<String> forgetPassword(String email) async {
    try {
      final message = await authRepo.sendPasswordResetEmail(email);
      return message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> deleteAccount() async {
    try {
      emit(AuthLoading());
      await authRepo.deleteAccount();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      emit(AuthLoading());
      final user = await authRepo.signInWithGoogle();

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
        _startUserDataStreams();
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  Future<void> updateProfilePhoto(String photoUrl) async {
    if (_currentUser == null) return;
    try {
      final updatedUser = await authRepo.updateProfilePhoto(
        _currentUser!.uid,
        photoUrl,
      );
      _currentUser = updatedUser;
      emit(Authenticated(updatedUser));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> updateProfileName(String name) async {
    if (_currentUser == null) return;
    try {
      final updatedUser = await authRepo.updateProfileName(
        _currentUser!.uid,
        name,
      );
      _currentUser = updatedUser;
      emit(Authenticated(updatedUser));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}

void _startUserDataStreams() {
  getIt<CartBloc>().add(WatchCartStarted());
  getIt<FavoriteBloc>().add(WatchFavoritesStarted());
  getIt<AddressBloc>().add(WatchAddressesStarted());
}
