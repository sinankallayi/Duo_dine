import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restro_delivery/app/components/loader.dart';

import '../controllers/auth_controller.dart';
import 'login_view.dart';
import 'register_view.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});
  @override
  Widget build(BuildContext context) {
    controller.checkUser();
    return Scaffold(
      body: Obx(() {
        switch (controller.authState.value) {
          case AuthState.login:
            return LoginView();
          case AuthState.register:
            return RegisterView();
          default:
            return Loader();
        }
      }),
    );
  }
}
