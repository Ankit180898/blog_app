import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_palette.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/signup_page.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_button.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:blog_app/features/navigation/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) {
        return const LoginPage();
      });
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                "assets/images/background_gif.png",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthFailure) {
                  showSnackbar(context, state.message);
                } else if (state is AuthSuccess) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomNavBar(
                          index: 0), // Wrap BottomNavBar in MaterialPageRoute
                    ),
                    (route) => false, // Remove all previous routes
                  );
                }
              },
              builder: (context, state) {
                if (state is AuthLoading) {
                  return Loader();
                }
                return Form(
                  key: formKey,
                  child: Column(
                    spacing: 16,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sign In.",
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppPalette.whiteColor,
                                fontSize: 50),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      AuthField(
                        hintText: "Email",
                        controller: emailController,
                      ),
                      AuthField(
                        hintText: "Password",
                        controller: passwordController,
                        isObscureText: true,
                      ),
                      AuthButton(
                        btnText: 'Sign In',
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  AuthLogin(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim()),
                                );
                          }
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, SignUpPage.route());
                        },
                        child: RichText(
                          text: TextSpan(
                              text: "Don't have an account? ",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: AppPalette.focusedColor),
                              children: [
                                TextSpan(
                                    text: 'Sign Up',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                            color: AppPalette.secondaryColor,
                                            fontWeight: FontWeight.bold)),
                              ]),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
