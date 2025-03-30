import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          Text('Duo Dine Delivery', style: TextStyle(fontSize: 20))
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 1200.ms, color: const Color(0xFF80DDFF))
              .animate() // this wraps the previous Animate in another Animate
              .fadeIn(duration: 1200.ms, curve: Curves.easeOutQuad)
              .slide(),
    );
  }
}
