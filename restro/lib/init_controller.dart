import 'package:get/get.dart';
import 'package:foodly_ui/functions/auth.dart';
import 'package:foodly_ui/screens/Restaurent/waiting/approval_screen.dart';
import 'package:foodly_ui/entry_point.dart';
import 'package:foodly_ui/services/notification_service.dart';

import 'constants.dart';
import 'data.dart';
class InitController extends GetxController {
  Future<void> check() async {
    try {
      await getUserInfo();
      NotificationService(); // Initialize notifications
      Get.offAll(() => (user != null && (localStorage.read('isCustomer') ?? true)) 
          ? const EntryPoint() 
          : const ApprovalScreen());
    } catch (_) {
      Get.offAll(() => const EntryPoint());
    }
  }
}
