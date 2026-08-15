import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/features/auth/presentation/bloc/cubits/auth_cubit.dart';
import 'package:shopping_app/features/auth/presentation/bloc/cubits/auth_page.dart';
import 'package:shopping_app/features/auth/presentation/bloc/cubits/auth_state.dart';
import 'package:shopping_app/features/auth/presentation/widgets/loading_screen.dart';
import 'package:shopping_app/features/home/presentation/widgets/home_tab.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      builder: (context, state) {
        print(state);
        if (state is Unauthenticated) {
          return AuthPage();
        }
        if (state is Authenticated) {
          return HomeTab();
        } else {
          return const LoadingScreen();
        }
      },
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
    );
  }
}
