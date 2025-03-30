import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/constants.dart';
import '../data/enums/delivery_status.dart';
import '../routes/app_pages.dart';

Future<void> login({required String email, required String password}) async {
  // login logic
  debugPrint('Logging in...');
  try {
    await account.createEmailPasswordSession(email: email, password: password);
    debugPrint('Login successful');
  } on AppwriteException catch (e) {
    Get.snackbar('Error', e.message.toString());
    debugPrint('Login failed: ${e.message}');
  }
}

Future<void> logout() async {
  // logout logic
  debugPrint('Logging out...');
  try {
    await account.deleteSession(sessionId: 'current');
    debugPrint('Logout successful');
    user = null;
    Get.offAndToNamed(AppPages.INITIAL);
  } on AppwriteException catch (e) {
    user = null;
    Get.offAndToNamed(AppPages.INITIAL);
    debugPrint('Logout failed: ${e.message}');
  }
}

Future<void> register({
  required String name,
  required String phone,
  required String email,
  required String password,
}) async {
  // register logic
  debugPrint('Registering user...');
  try {
    user = await account.create(userId: ID.unique(), email: email, password: password, name: name);

    var deliveryPerson = await databases.createDocument(
      databaseId: dbId,
      collectionId: deliveryPersonsCollection,
      documentId: user!.$id,
      data: {
        "phone": phone,
        "name": name,
        "location": "",
        "deliveryStatus": DeliveryStatus.online.value,
      },
    );
  } on AppwriteException catch (e) {
    Get.snackbar('Error', e.message.toString());
    debugPrint('Error: ${e.message}');
  }
}

Future getUserInfo() async {
  // get user info
  try {
    user = await account.get();
  } on AppwriteException catch (e) {
    debugPrint('Error: ${e.message}');
  }
}

Future<void> loginWithGoogle() async {
  debugPrint('Logging in with Google...');
  try {
    await account.createOAuth2Session(provider: OAuthProvider.google, scopes: ["profile", "email"]);
    debugPrint('Google login successful');
  } on AppwriteException catch (e) {
    debugPrint('Google login failed: ${e.message}');
  }
}
