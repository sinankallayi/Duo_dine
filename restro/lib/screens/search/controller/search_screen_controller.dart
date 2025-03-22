import 'package:appwrite/appwrite.dart';
import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/models/restaurant_model.dart';
import 'package:get/get.dart';

class SearchScreenController extends GetxController {
  RxBool showSearchResult = false.obs;
  RxBool isLoading = true.obs;
  RxList<Restaurant> restaurants = <Restaurant>[].obs;

  @override
  void onInit() {
    getSearchResult("");
    super.onInit();
  }

  void getSearchResult(String keyword) async {
    isLoading.value = true;

    try {
      final result = await db.listDocuments(
        databaseId: dbId,
        collectionId: restaurantCollection,
        queries: keyword.trim().isEmpty
            ? [Query.equal("approved", true)]
            : [Query.contains('name', keyword), Query.equal("approved", true), Query.limit(1500)],
      );
      // Assuming result.documents are iterables of document data and Restaurant.fromJson exists
      restaurants.value =
          result.documents.map((doc) => Restaurant.fromJson(doc.data)).toList();
      showSearchResult.value = true;
      print('Search results: ${restaurants.length}');
    } on AppwriteException catch (e) {
      print('Error fetching search results: $e');
      showSearchResult.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  void searchRestaurants(String value) {
    if (value.isEmpty) {
      showSearchResult.value = false;
      getSearchResult('');
    } else if (value.length >= 3) {
      getSearchResult(value);
    }
  }
}
