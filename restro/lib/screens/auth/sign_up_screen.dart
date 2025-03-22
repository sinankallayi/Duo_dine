import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodly_ui/data.dart';
import 'package:foodly_ui/functions/auth.dart';
import 'package:foodly_ui/screens/chooseType/choose_type_screen.dart';
import 'package:get/get.dart';
import 'sign_in_screen.dart';

import '../../components/buttons/socal_button.dart';
import '../../components/welcome_text.dart';
import '../../constants.dart';
import '../signUp/components/sign_up_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WelcomeText(
                title: "Create Account",
                text: "Enter your Name, Email and Password \nfor sign up.",
              ),

              //* Sign Up Form
              const SignUpForm(),
              const SizedBox(height: defaultPadding),

              // Already have account
              Center(
                child: Text.rich(
                  TextSpan(
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontWeight: FontWeight.w500),
                    text: "Already have account? ",
                    children: <TextSpan>[
                      TextSpan(
                        text: "Sign In",
                        style: const TextStyle(color: primaryColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.offAll(const SignInScreen());
                          },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              Center(
                child: Text(
                  "By Signing up you agree to our Terms \nConditions & Privacy Policy.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: defaultPadding),
              kOrText,
              const SizedBox(height: defaultPadding),

              // Google
              SocalButton(
                press: () async {
                  try {
                    await loginWithGoogle();
                    user = await account.get();
                    Get.offAll(const ChooseTypeScreen());
                  } catch (e) {
                    // Handle error
                    print("Error during Google login: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error during Google login: $e")),
                    );
                  }
                },
                text: "Connect with Google",
                color: const Color(0xFF4285F4),
                icon: SvgPicture.asset(
                  'assets/icons/google.svg',
                ),
              ),
              const SizedBox(height: defaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}
