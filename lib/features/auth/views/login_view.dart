import 'package:fernstack/constants/app_colors.dart';
import 'package:fernstack/core/dev_tools.dart';
import 'package:fernstack/extensions/validators.dart';
import 'package:fernstack/features/auth/controller/auth_controller.dart';
import 'package:fernstack/features/auth/views/signup_view.dart';
import 'package:fernstack/features/auth/widgets/custom_text_field.dart';
import 'package:fernstack/services/auth/extra/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icons_plus/icons_plus.dart';

class LoginView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const LoginView());
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final logInFormKey = GlobalKey<FormState>();
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late bool isPasswordObscured;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    emailController.addListener(() {
      setState(() {});
    });
    passwordController.addListener(() {
      setState(() {});
    });
    isPasswordObscured = true;
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final asyncAuthState = ref.watch(asyncAuthStateProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const Spacer(),
            SvgPicture.asset(
              'assets/svgs/login.svg',
              width: size.width * 0.5,
            ),
            const SizedBox(height: 30),
            Text(
              "Log In to Continue",
              style: Theme.of(context).primaryTextTheme.bodyLarge,
            ),
            const Spacer(),
            Container(
              height: size.height * 0.6,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Form(
                key: logInFormKey,
                child: Column(
                  children: [
                    const Spacer(),
                    CustomTextField(
                      validator: (input) =>
                          input!.isValidEmail() || input.isEmpty
                              ? null
                              : "Please enter a valid email address",
                      textEditingController: emailController,
                      obscureText: false,
                      suffixIcon: emailController.text.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.cancel_outlined),
                              onPressed: emailController.clear,
                              color: AppColors.lightPurple,
                              iconSize: 20,
                            ),
                      labelText: "Email",
                      hintText: "Enter Email",
                      textInputType: TextInputType.emailAddress,
                      onChanged: (_) {},
                    ),
                    const SizedBox(height: 30),
                    CustomTextField(
                      validator: (input) => input!.isValidPassword() ||
                              input.isEmpty
                          ? null
                          : "Must include [A-Z], [a-z], [0-9] and a special characters.",
                      textEditingController: passwordController,
                      suffixIcon: passwordController.text.isEmpty
                          ? null
                          : IconButton(
                              iconSize: 20,
                              color: AppColors.lightPurple,
                              icon: Icon(isPasswordObscured
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined),
                              onPressed: () {
                                setState(() {
                                  isPasswordObscured = !isPasswordObscured;
                                });
                              },
                            ),
                      labelText: "Password",
                      hintText: "Enter Password",
                      textInputType: TextInputType.visiblePassword,
                      onChanged: (_) {},
                      obscureText: isPasswordObscured,
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                        "By continuing you agree to the Terms and Conditions"),
                    const Spacer(),
                    FilledButton(
                      onPressed: asyncAuthState.isLoading
                          ? null
                          : () async {
                              if (logInFormKey.currentState!.validate()) {
                                await ref
                                    .read(asyncAuthStateProvider.notifier)
                                    .logInEmail(
                                      context: context,
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                              }
                            },
                      style: FilledButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: AppColors.deepPurple,
                        disabledForegroundColor: Colors.black45,
                        disabledBackgroundColor: Colors.grey.shade300,
                        textStyle:
                            Theme.of(context).primaryTextTheme.titleLarge,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fixedSize: Size(size.width, 50),
                      ),
                      child: asyncAuthState.isLoading &&
                              asyncAuthState.value?.provider ==
                                  AuthProvider.email
                          ? const CupertinoActivityIndicator(
                              color: Colors.black,
                            )
                          : const Text(
                              "Log In",
                            ),
                    ),
                    const Spacer(),
                    OutlinedButton(
                      onPressed: asyncAuthState.isLoading
                          ? null
                          : () async => await ref
                              .read(asyncAuthStateProvider.notifier)
                              .logInGoogle(context: context),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.padded,
                        fixedSize: Size(size.width, 50),
                        disabledBackgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: asyncAuthState.isLoading &&
                              asyncAuthState.value?.provider ==
                                  AuthProvider.google
                          ? const CupertinoActivityIndicator(
                              color: Colors.black)
                          : RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.titleMedium,
                                children: [
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Logo(
                                      Logos.google,
                                      size: 25,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: "  Continue with Google",
                                  ),
                                ],
                              ),
                            ),
                    ),
                    const SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: "Sign Up",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  SignUpView.route(),
                                );
                              },
                            style: const TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
