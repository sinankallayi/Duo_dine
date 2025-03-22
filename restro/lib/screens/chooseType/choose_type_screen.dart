import 'package:flutter/material.dart';
import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/data.dart';
import 'package:foodly_ui/entry_point.dart';
import 'package:foodly_ui/screens/Restaurent/waiting/approval_screen.dart';
import 'package:foodly_ui/screens/splash/splash_view.dart';
import 'package:get/get.dart';

class ChooseTypeScreen extends GetView<ChooseTypeController> {
  const ChooseTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Type'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Navigate to customer sign-in screen
                await localStorage.write('isCustomer', true);
                // user = await account.get();
                Get.offAll(const SplashView());
              },
              child: const Text('Sign in as Customer'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                // Navigate to restaurant owner sign-in screen
                await localStorage.write('isCustomer', false);
                // user = await account.get();
                Get.offAll(const SplashView());
                // Get.offAll(const ApprovalScreen());
              },
              child: const Text('Sign in as Restaurant Owner'),
            ),
          ],
        ).paddingAll(defaultPadding),
      ),
    );
  }
}

class ChooseTypeController extends GetxController {
  // Add your controller properties and methods here
}
