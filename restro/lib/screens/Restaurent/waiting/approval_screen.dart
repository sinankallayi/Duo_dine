import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodly_ui/functions/approval.dart';
import 'package:foodly_ui/screens/Restaurent/home/rest_home.dart';
import 'package:foodly_ui/screens/Restaurent/register/rest_register.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../splash/splash_view.dart';

class ApprovalScreen extends GetView<ApprovalController> {
  const ApprovalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ApprovalController());
    return  Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 5,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(30.0),
                child: CupertinoActivityIndicator(color: primaryColor,radius: 20,),
              ),
              const Text(
                'Waiting for approval...',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const Text(
                'System will auto check for approval every 15 seconds.',
                style: TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: OutlinedButton(
                        onPressed: () async {
                          await localStorage.write('isCustomer', true);
                          Get.offAll(const SplashView());
                        },
                        child: const Text('Sign in as Customer'),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// controller
class ApprovalController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkApprovalStatus();
  }

  Future<void> _checkApprovalStatus() async {
    while (true) {
      var approvalStatus = await checkApproval();
      if (approvalStatus == 'approved') {
        Get.offAll(() => const RestHomeScreen());
        break;
      } else if (approvalStatus == 'not registered') {
        Get.offAll(() => RestRegisterScreen());
        break;
      }
      await Future.delayed(const Duration(seconds: 15));
    }
  }
}
