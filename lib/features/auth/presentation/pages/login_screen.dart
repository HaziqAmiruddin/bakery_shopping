import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/core/gen/assets.gen.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/theme/colors_theme.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/core/utils/app_navigator.dart';
import 'package:shopping_app/core/utils/sized_context.dart';
import 'package:shopping_app/core/widgets/app_button.dart';
import 'package:shopping_app/core/widgets/app_scaffold.dart';
import 'package:shopping_app/core/widgets/app_svg_viewer.dart';
import 'package:shopping_app/features/auth/presentation/bloc/cubits/auth_cubit.dart';
import 'package:shopping_app/features/auth/presentation/widgets/google_sign_in_button.dart';
import 'package:shopping_app/features/auth/presentation/widgets/my_textfield.dart';
import 'package:shopping_app/features/auth/presentation/widgets/password_textfield.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback? togglePages;
  const LoginScreen({super.key, required this.togglePages});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AppColors get colorOwn => context.theme.appColors;
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  late final authCubit = context.read<AuthCubit>();

  void login() {
    final String email = emailController.text;
    final String pw = pwController.text;

    if (email.isNotEmpty && pw.isNotEmpty) {
      authCubit.login(email, pw);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please Enter Email & Password Correctly"),
        ),
      );
    }
  }

  void openForgetPaswordBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorOwn.primaryShade3,
        title: Text("Forget Password ?"),
        content: MyTextfield(
          controller: emailController,
          hintText: "Enter Email",
        ),
        actions: [
          TextButton(
            onPressed: () => appPop(context),
            child: const Text("Cancel"),
          ),

          TextButton(
            onPressed: () async {
              String message = await authCubit.forgetPassword(
                emailController.text,
              );

              if (message == "Password reset email! Check Inbox") {
                appPop(context);
                emailController.clear();
              }

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message)));
            },
            child: const Text("Reset"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorOwn = context.theme.appColors;
    final textOwn = context.theme.appTypography;
    return AppScaffold(
      appBar: AppBar(title: Text("SIGN IN"), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppSvgViewer(Assets.icons.user, width: 80, color: colorOwn.primary),
            const SizedBox(height: 25),
            Text("SHOPPING APP", style: textOwn.displaySmall),
            const SizedBox(height: 25),
            //email
            MyTextfield(controller: emailController, hintText: "Email"),
            const SizedBox(height: 25),
            //password
            PasswordTextfield(hintText: "Password", controller: pwController),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => openForgetPaswordBox(),
                  child: Text(
                    "Forget Password?",
                    style: textOwn.labelLarge.copyWith(
                      color: colorOwn.gray2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: context.widthPx,
              height: 60,
              child: AppButton(
                title: "LOGIN",
                textStyle: textOwn.bodyLarge,
                onPressed: login,
                margin: EdgeInsets.zero,
                padding: WidgetStateProperty.all<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: Dimens.padding),
                ),
              ),
            ),
            SizedBox(height: 25),
            Row(
              children: [
                Expanded(child: Divider()),
                Text("Or Sign In With"),
                Expanded(child: Divider()),
              ],
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GoogleSignInButton(
                  onTap: () async {
                    authCubit.signInWithGoogle();
                    //print("pressed");
                  },
                ),
              ],
            ),
            SizedBox(height: 25),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account ? ",
                  style: textOwn.labelLarge.copyWith(color: colorOwn.gray4),
                ),
                GestureDetector(
                  onTap: widget.togglePages,
                  child: Text(
                    "Register Now",
                    style: textOwn.labelLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
