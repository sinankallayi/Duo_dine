import 'package:flutter/material.dart';
import 'package:foodly_ui/entry_point.dart';
import 'package:foodly_ui/functions/auth.dart';
import 'package:foodly_ui/screens/Restaurent/waiting/approval_screen.dart';
import 'package:foodly_ui/services/notification_service.dart';
import 'package:get/get.dart';

import 'constants.dart';
import 'data.dart';

class InitController extends GetxController {
  Future<void> check() async {
    try {
      await getUserInfo();
      NotificationService(); // Initialize notifications
      if (user != null) {
        isCustomer = localStorage.read('isCustomer') ?? true;

        if (isCustomer) {
          Get.offAll(() => const EntryPoint());
        } else {
          Get.offAll(() => const ApprovalScreen());
        }
      } else {
        Get.offAll(() => const EntryPoint());
      }
    } catch (e) {
      debugPrint('Error checking user info: $e');
      Get.offAll(() => const EntryPoint());
    }
  }
}
