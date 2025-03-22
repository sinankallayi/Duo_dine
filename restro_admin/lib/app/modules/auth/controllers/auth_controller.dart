import 'package:get/get.dart';
import 'package:restro_admin/app/data/constants.dart';
import 'package:restro_admin/app/routes/app_pages.dart';

class AuthController extends GetxController {
  final count = 0.obs;
  @override
  Future<void> onInit() async {
    try {
      user = await account.get();
    } on Exception catch (e) {
      print(e);
    }

    if (user == null) {
      try {
        await account.createEmailPasswordSession(
          email: 'admin@duodine.com',
          password: "123456789",
        );

        user = await account.get();
      } on Exception catch (e) {
        print(e);
      }
    }

    if (user != null) {
      print(user!.email);
      Get.offAndToNamed(Routes.HOME);
    }
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

  void increment() => count.value++;
}
