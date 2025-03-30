import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '/app/data/constants.dart';

import 'app/functions/customize_error_handling.dart';
import 'app/routes/app_pages.dart';

void main() {
  customizeErrorHandling();
  WidgetsFlutterBinding.ensureInitialized();
  //client = Client().setProject('restro');
  client = Client().setProject('67dc5f7e003032d8838b');

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Duo Dine Delivery",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
