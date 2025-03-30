import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';
import '/app/data/constants.dart';
import '/app/routes/app_pages.dart';

enum AuthState { loading, login, register, home }

class AuthController extends GetxController {
  var authState = AuthState.loading.obs;
  void checkUser() async {
    try {
      user = await account.get();
    } on Exception catch (e) {
      print(e);
    }
    print("RAZI ${user?.email}");
    print("RAZI: labels ${user?.labels.contains('customer')}");
    if (user == null) {
      showLogin();
    } else {
      showHome();
    }
  }

  void showLogin() {
    authState.value = AuthState.login;
  }

  void showRegister() {
    authState.value = AuthState.register;
  }

  void showHome() {
    authState.value = AuthState.home;
    Get.offAllNamed(Routes.HOME);
  }

  Future<void> logout() async {
    try {
      await account.deleteSession(sessionId: 'current');
      print('Logout successful');
      user = null;
    } on AppwriteException catch (e) {
      user = null;
      print('Logout failed: ${e.message}');
    }
  }
}
