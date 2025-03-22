import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodly_ui/data.dart';
import 'package:foodly_ui/functions/auth.dart';
import 'package:foodly_ui/screens/chooseType/choose_type_screen.dart';
import 'package:get/get.dart';

import '../../components/buttons/socal_button.dart';
import '../../components/welcome_text.dart';
import '../../constants.dart';
import 'sign_up_screen.dart';
import 'components/sign_in_form.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WelcomeText(
                title: "Welcome to",
                text:
                    "Enter your Phone number or Email \naddress for sign in. Enjoy your food :)",
              ),
              //* Sign In Form
              const SignInForm(),
              const SizedBox(height: defaultPadding),
              kOrText,
              const SizedBox(height: defaultPadding * 1.5),

              Center(
                child: Text.rich(
                  TextSpan(
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontWeight: FontWeight.w600),
                    text: "Don’t have account? ",
                    children: <TextSpan>[
                      TextSpan(
                        text: "Create new account.",
                        style: const TextStyle(color: primaryColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(const SignUpScreen());
                          },
                      )
                    ],
                  ),
                ),
              ),
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to sign in with Google: $e')),
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
