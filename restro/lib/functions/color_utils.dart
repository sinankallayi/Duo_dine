import 'dart:math';

import 'package:flutter/widgets.dart';

class ColorUtils {
  static Color getRandomLightColor(
      {double lightness = 0.8, double saturation = 0.4, double opacity = 1.0}) {
    final Random random = Random();
    return HSLColor.fromAHSL(
      opacity, // Full opacity
      random.nextDouble() * 360,
      saturation, // High saturation
      lightness, // High lightness for a light color
    ).toColor();
  }
}
