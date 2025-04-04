import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '/app/data/constants.dart';

import 'app/functions/customize_error_handling.dart';
import 'app/routes/app_pages.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  customizeErrorHandling();
  WidgetsFlutterBinding.ensureInitialized();
  //client = Client().setProject('restro');
  client = Client().setProject(projectId);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Duo Dine Delivery",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
