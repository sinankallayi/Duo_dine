import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Duo Dine Admin',
          style: TextStyle(fontSize: 20),
        )
            .animate(onPlay: (controller) => controller.repeat())
            .shimmer(duration: 1200.ms, color: const Color(0xFF80DDFF))
            .animate() // this wraps the previous Animate in another Animate
            .fadeIn(duration: 1200.ms, curve: Curves.easeOutQuad)
            .slide(),
      ),
    );
  }
}
