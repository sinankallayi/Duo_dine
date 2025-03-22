import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:foodly_ui/init_controller.dart';

import 'package:get/get.dart';

class SplashView extends GetView<InitController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.check();
    return Scaffold(
      body: Center(
        child: Text(
          'Duo Dine',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      )
          .animate(onPlay: (controller) => controller.repeat())
          .shimmer(duration: 1200.ms, color: const Color(0xFF80DDFF))
          .animate() // this wraps the previous Animate in another Animate
          .fadeIn(duration: 1200.ms, curve: Curves.easeOutQuad)
          .slide(),
    );
  }
}
