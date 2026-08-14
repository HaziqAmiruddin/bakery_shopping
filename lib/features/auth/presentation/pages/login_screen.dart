import 'package:flutter/material.dart';
import 'package:shopping_app/core/gen/assets.gen.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/core/utils/sized_context.dart';
import 'package:shopping_app/core/widgets/app_button.dart';
import 'package:shopping_app/core/widgets/app_scaffold.dart';
import 'package:shopping_app/core/widgets/app_svg_viewer.dart';
import 'package:shopping_app/features/auth/presentation/widgets/my_textfield.dart';
import 'package:shopping_app/features/auth/presentation/widgets/password_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final pwController = TextEditingController();

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
                Text(
                  "Forget Password?",
                  style: textOwn.labelLarge.copyWith(
                    color: colorOwn.gray2,
                    fontWeight: FontWeight.bold,
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
                onPressed: () {},
                margin: EdgeInsets.zero,
                padding: WidgetStateProperty.all<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: Dimens.padding),
                ),
              ),
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account ? ",
                  style: textOwn.labelLarge.copyWith(color: colorOwn.gray4),
                ),
                Text(
                  "Register Now",
                  style: textOwn.labelLarge.copyWith(
                    fontWeight: FontWeight.bold,
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
