import 'package:flutter/material.dart';
import '/screens/auth/sign_in_screen.dart';

Future<dynamic> showLoginBottomSheet(BuildContext context) {
    return showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                padding: const EdgeInsets.all(20.0),
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Please sign in to continue',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInScreen()),
                        );
                      },
                      child: const Text('Sign In'),
                    ),
                  ],
                ),
              );
            },
          );
  }