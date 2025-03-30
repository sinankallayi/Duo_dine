import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import '../../../functions/auth.dart';
import '../../../functions/validations.dart';
import '/app/modules/auth/controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, title: const Text("Sign Up")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WelcomeText(
                title: "Create Account",
                text: "Enter your Name, Email and Password \nfor sign up.",
              ),

              // Sign Up Form
              SignUpForm(
                onSubmit: (String fullName, String phone, String email, String password) async {
                  await register(name: fullName, email: email, phone: phone, password: password);
                  controller.checkUser();
                },
              ),
              const SizedBox(height: 16),

              // Already have account
              Center(
                child: Text.rich(
                  TextSpan(
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500),
                    text: "Already have account? ",
                    children: <TextSpan>[
                      TextSpan(
                        text: "Sign In",
                        style: const TextStyle(color: Color(0xFF22A45D)),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                // Navigate to Sign In Screen
                              },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  "By Signing up you agree to our Terms \nConditions & Privacy Policy.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text("Or", style: TextStyle(color: Color(0xFF010F07).withOpacity(0.7))),
              ),
              const SizedBox(height: 16),

              // Facebook
              SocalButton(
                press: () {},
                text: "Connect with Facebook",
                color: const Color(0xFF395998),
                icon: SvgPicture.asset(
                  'assets/icons/facebook.svg',
                  colorFilter: const ColorFilter.mode(Color(0xFF395998), BlendMode.srcIn),
                ),
              ),
              const SizedBox(height: 16),

              // Google
              SocalButton(
                press: () {},
                text: "Connect with Google",
                color: const Color(0xFF4285F4),
                icon: SvgPicture.asset('assets/icons/google.svg'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class WelcomeText extends StatelessWidget {
  final String title, text;

  const WelcomeText({super.key, required this.title, required this.text});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16 / 2),
        Text(text, style: TextStyle(color: Color(0xFF868686))),
        const SizedBox(height: 24),
      ],
    );
  }
}

class SocalButton extends StatelessWidget {
  final Color color;
  final String text;
  final Widget icon;
  final GestureTapCallback press;

  const SocalButton({
    super.key,
    required this.color,
    required this.icon,
    required this.press,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: padding,
          backgroundColor: color,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        ),
        onPressed: press,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              height: 28,
              width: 28,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child: icon,
            ),
            const Spacer(flex: 2),
            Text(
              text.toUpperCase(),
              style: Theme.of(
                context,
              ).textTheme.bodySmall!.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  final Function(String fullName, String phone, String email, String password) onSubmit;
  const SignUpForm({super.key, required this.onSubmit});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String? _fullName;
  String? _phone;
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
            decoration: const InputDecoration(
              hintText: "Full Name",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFF3F2F2))),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFF3F2F2))),
            ),
          ),
          const SizedBox(height: 16),

          TextFormField(
            validator: phoneNumberValidator.call,
            onSaved: (value) => _phone = value,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              hintText: "Phone Number",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFF3F2F2))),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFF3F2F2))),
            ),
          ),

          const SizedBox(height: 16),

          // Email Field
          TextFormField(
            validator: emailValidator.call,
            onSaved: (value) {
              _email = value;
            },
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Email Address",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFF3F2F2))),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFF3F2F2))),
            ),
          ),
          const SizedBox(height: 16),

          // Password Field
          TextFormField(
            obscureText: _obscureText,
            validator: passwordValidator.call,
            onSaved: (value) {
              _password = value;
            },
            textInputAction: TextInputAction.next,
            onChanged: (value) {},
            decoration: InputDecoration(
              hintText: "Password",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFF3F2F2))),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFF3F2F2))),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child:
                    _obscureText
                        ? const Icon(Icons.visibility_off, color: Color(0xFF868686))
                        : const Icon(Icons.visibility, color: Color(0xFF868686)),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Confirm Password Field
          TextFormField(
            obscureText: _obscureText,
            decoration: InputDecoration(
              hintText: "Confirm Password",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFF3F2F2))),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFF3F2F2))),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child:
                    _obscureText
                        ? const Icon(Icons.visibility_off, color: Color(0xFF868686))
                        : const Icon(Icons.visibility, color: Color(0xFF868686)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Sign Up Button
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                widget.onSubmit(_fullName ?? "", _phone ?? "", _email ?? "", _password ?? "");
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF22A45D),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 40),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Sign Up"),
          ),
        ],
      ),
    );
  }
}
