import 'package:appwrite/appwrite.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/models/restaurant_model.dart';
import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  RxList<Restaurant> restaurants = <Restaurant>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getRestaurents();
    super.onInit();
  }

  Future getRestaurents() async {
    restaurants.clear();
    try {
      var response = await db.listDocuments(
          databaseId: dbId,
          collectionId: restaurantCollection,
          queries: [Query.equal("approved", true)]);

      restaurants.value =
          response.documents.map((e) => Restaurant.fromJson(e.data)).toList();
    } on AppwriteException catch (e) {
      Fluttertoast.showToast(msg: e.message!);
    }
  }
}
