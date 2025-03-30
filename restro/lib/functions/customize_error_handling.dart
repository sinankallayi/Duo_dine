import 'package:flutter/material.dart';

void customizeErrorHandling() {
  FlutterError.onError = (FlutterErrorDetails details) {
    // Suppress the specific exception from being printed
    List<String> stringsToCheck = ["mouse_tracker","MouseTracker", "GESTURES LIBRARY ","handleWindowFocusChanged"];

    bool containsAny = stringsToCheck.any((str) => details.exception.toString().contains(str));

    if (containsAny) {
      // Let the default handler log other errors
      FlutterError.dumpErrorToConsole(details);
    }
  };
}
