import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/core/inject/injection.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/features/auth/data/firebase_auth_repo.dart';
import 'package:shopping_app/features/auth/presentation/bloc/cubits/auth_cubit.dart';
import 'package:shopping_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:shopping_app/features/home/presentation/bloc/bloc/fav_bloc.dart';
import 'package:shopping_app/features/map/presentation/bloc/location_bloc.dart';
import 'package:shopping_app/features/map/presentation/bloc/location_event.dart';
import 'package:shopping_app/features/notification/presentation/bloc/notification_cubit.dart';
import 'package:shopping_app/features/splash/presentation/splash_screen.dart';

class ShoppingApp extends StatelessWidget {
  ShoppingApp({super.key});

  final firebaseAuthRepo = FirebaseAuthRepo();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) =>
              AuthCubit(authRepo: firebaseAuthRepo)..checkAuth(),
        ),

        BlocProvider<NotificationCubit>(
          create: (_) => getIt<NotificationCubit>(),
        ),
        BlocProvider<LocationBloc>(
          create: (_) => getIt<LocationBloc>()..add(FetchCurrentLocation()),
        ),
        BlocProvider<CartBloc>.value(value: getIt<CartBloc>()),
        BlocProvider<FavoriteBloc>.value(value: getIt<FavoriteBloc>()),
      ],
      child: MaterialApp(
        title: "ShoppingBakeryApp",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
      ),
    );
  }
}
