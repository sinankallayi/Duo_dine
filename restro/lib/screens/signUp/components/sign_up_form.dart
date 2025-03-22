import 'package:flutter/material.dart';
import 'package:foodly_ui/data.dart';
import 'package:foodly_ui/functions/auth.dart';
import 'package:foodly_ui/screens/chooseType/choose_type_screen.dart';
import 'package:get/route_manager.dart';

import '../../../constants.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String? _fullName;
  String? _email;
  String? _password;

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Full Name Field
          TextFormField(
            validator: requiredValidator.call,
            onSaved: (value) {
              _fullName = value;
            },
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(hintText: "Full Name"),
          ),
          const SizedBox(height: defaultPadding),

          // Email Field
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
            textInputAction: TextInputAction.next,
            onChanged: (value) {},
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

          // Confirm Password Field
          TextFormField(
            obscureText: _obscureText,
            decoration: InputDecoration(
              hintText: "Confirm Password",
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
          // Sign Up Button
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                await register(name: _fullName, email: _email, password: _password);
                if (user != null) {
                  Get.offAll(const ChooseTypeScreen());
                }
              }
            },
            child: const Text("Sign Up"),
          ),
        ],
      ),
    );
  }
}
