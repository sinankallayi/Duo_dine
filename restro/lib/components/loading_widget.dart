import 'package:flutter/material.dart';

Widget loadingWidget() {
  return Center(
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: const CircularProgressIndicator(),
    ),
  );
}
