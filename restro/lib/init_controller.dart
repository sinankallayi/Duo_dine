import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/data.dart';
import 'package:foodly_ui/entry_point.dart';
import 'package:foodly_ui/functions/auth.dart';
import 'package:foodly_ui/notification_services.dart';
import 'package:foodly_ui/screens/Restaurent/waiting/approval_screen.dart';
import 'package:get/get.dart';

FirebaseMessaging fcm_messaging = FirebaseMessaging.instance;

class InitController extends GetxController {
  final count = 0.obs;
  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> check() async {
    log('Checking user info');
    try {
      await getUserInfo();
      
      // await Future.delayed(const Duration(seconds: 2));

      if (user != null) {
        localStorage.read('isCustomer') == null
            ? isCustomer = true
            : isCustomer = localStorage.read('isCustomer');
        NotificationSettings settings = await fcm_messaging.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
        NotificationService().initializeNotifications();
        if (isCustomer) {
          try {
            String? token = await fcm_messaging.getToken();
            await account.createPushTarget(
              targetId: user!.$id,
              identifier: token!,
              providerId: notifcationProviderId,
            );
            await messaging.createSubscriber(
              topicId: notifcationsTopic,
              subscriberId: ID.unique(),
              targetId: user!.$id,
            );
          } on AppwriteException catch (e) {
            print('Error creating subscriber: ${e.message}');
          }

          Get.offAll(() => const EntryPoint());
          print('User granted permission: ${settings.authorizationStatus}');
        } else {
          Get.offAll(() => const ApprovalScreen());
        }
      } else {
        Get.offAll(() => const EntryPoint());
      }
    } catch (e) {
      log('Error checking user info: $e');
      Get.offAll(() => const EntryPoint());
    }
  }
}
