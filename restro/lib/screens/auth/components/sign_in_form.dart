import 'package:flutter/material.dart';
import 'package:foodly_ui/functions/auth.dart';
import 'package:foodly_ui/screens/chooseType/choose_type_screen.dart';
import 'package:get/route_manager.dart';

import '../../../constants.dart';
import '../forgot_password_screen.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            validator: emailValidator.call,
            onSaved: (value) {
              _email = value;
            },
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: "Email Address"),
          ),
          const SizedBox(height: defaultPadding),

          // Password Field
          TextFormField(
            obscureText: _obscureText,
            validator: passwordValidator.call,
            onSaved: (value) {
              _password = value;
            },
            decoration: InputDecoration(
              hintText: "Password",
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: _obscureText
                    ? const Icon(Icons.visibility_off, color: bodyTextColor)
                    : const Icon(Icons.visibility, color: bodyTextColor),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),

          // Forget Password
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ForgotPasswordScreen(),
              ),
            ),
            child: Text(
              "Forget Password?",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: defaultPadding),

          // Sign In Button
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                var isLogedIn = await login(email: _email!, password: _password!);
                if (isLogedIn) {
                  Get.offAll(() => const ChooseTypeScreen());
                }
                // just for demo
                // Navigator.pushAndRemoveUntil(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const FindRestaurantsScreen(),
                //   ),
                //   (_) => true,
                // );
              }
            },
            child: const Text("Sign in"),
          ),
        ],
      ),
    );
  }
}
