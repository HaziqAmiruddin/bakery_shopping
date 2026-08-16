import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/core/gen/assets.gen.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/core/utils/sized_context.dart';
import 'package:shopping_app/core/utils/validator_form_field.dart';
import 'package:shopping_app/core/widgets/app_button.dart';
import 'package:shopping_app/core/widgets/app_scaffold.dart';
import 'package:shopping_app/core/widgets/app_svg_viewer.dart';
import 'package:shopping_app/features/auth/presentation/bloc/cubits/auth_cubit.dart';
import 'package:shopping_app/features/auth/presentation/widgets/my_textfield.dart';
import 'package:shopping_app/features/auth/presentation/widgets/password_textfield.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback? togglePages;

  const RegisterScreen({super.key, required this.togglePages});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final pwController = TextEditingController();
  final confirmController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // void register() {
  //   final String name = nameController.text;
  //   final String email = emailController.text;
  //   final String pw = pwController.text;
  //   final String confirmpw = confirmController.text;

  //   final authCubit = context.read<AuthCubit>();

  //   if (email.isNotEmpty &&
  //       name.isNotEmpty &&
  //       pw.isNotEmpty &&
  //       confirmpw.isNotEmpty) {
  //     if (pw == confirmpw) {
  //       authCubit.register(name, email, pw);
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Passwords Do Not Match !!")),
  //       );
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Please Complete All Field !!")),
  //     );
  //   }
  // }

  void register() {
    if (!formKey.currentState!.validate()) return;

    final String name = nameController.text;
    final String email = emailController.text;
    final String pw = pwController.text;
    final String confirmpw = confirmController.text;

    final authCubit = context.read<AuthCubit>();

    if (pw != confirmpw) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords Do Not Match !!")),
      );
      return;
    }

    authCubit.register(name, email, pw);
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    pwController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorOwn = context.theme.appColors;
    final textOwn = context.theme.appTypography;
    return AppScaffold(
      appBar: AppBar(title: Text("REGISTER"), centerTitle: true),
      body: Center(
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppSvgViewer(
                Assets.icons.userAdd,
                width: 80,
                color: colorOwn.primary,
              ),
              const SizedBox(height: 25),
              Text("SHOPPING APP", style: textOwn.displaySmall),
              const SizedBox(height: 15),
              Text("Let's Create an Account", style: textOwn.headlineMedium),
              const SizedBox(height: 25),
              MyTextfield(
                controller: nameController,
                hintText: "name",
                validator: validateName,
              ),
              const SizedBox(height: 25),
              //email
              MyTextfield(
                controller: emailController,
                hintText: "Email",
                validator: validateEmail,
              ),
              const SizedBox(height: 25),
              //password
              PasswordTextfield(
                hintText: "Password",
                controller: pwController,
                validator: validateSignUpPassword,
              ),
              const SizedBox(height: 25),
              //confirm password
              PasswordTextfield(
                hintText: "Confrim Password",
                controller: confirmController,
                validator: validateSignUpPassword,
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: context.widthPx,
                height: 60,
                child: AppButton(
                  title: "Register New User",
                  textStyle: textOwn.bodyLarge,
                  onPressed: register,
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
                    "Already have an account ? ",
                    style: textOwn.labelLarge.copyWith(color: colorOwn.gray4),
                  ),
                  GestureDetector(
                    onTap: widget.togglePages,
                    child: Text(
                      "Login Now",
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
      ),
    );
  }
}
