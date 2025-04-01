import 'package:appwrite/appwrite.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/models/restaurant_model.dart';
import 'package:get/get.dart';

import '../../functions/color_utils.dart';
import '../../services/gen_ai_service.dart';

class HomeScreenController extends GetxController {
  RxList<Restaurant> restaurants = <Restaurant>[].obs;
  
  RxBool introLoading = false.obs;
  RxString intro = "".obs;
  Rx<Color> introBg = ColorUtils.getRandomLightColor().obs;

  GenAiService genAi = GenAiService();

  @override
  void onInit() {
    // TODO: implement onInit
    getRestaurents();
    generateIntroText();
    super.onInit();
  }

  Future getRestaurents() async {
    restaurants.clear();
    try {
      var response = await db.listDocuments(
          databaseId: dbId,
          collectionId: restaurantCollection,
          queries: [Query.equal("approved", true)]);
      print("Fetched Restaurants: ${response.documents.length}");
      restaurants.assignAll(response.documents.map((e) => Restaurant.fromJson(e.data)).toList());

      // restaurants.value =
      //     response.documents.map((e) => Restaurant.fromJson(e.data)).toList();
    } on AppwriteException catch (e) {
      print("Appwrite Error: ${e.message}");
      Fluttertoast.showToast(msg: e.message!);
    }
  }

  void generateIntroText() async {
    if(introLoading.value == true) return;
    introLoading.value = true;
    introBg.value = ColorUtils.getRandomLightColor();
    intro.value = await genAi.generateIntro();
    introLoading.value = false;
  }
}
