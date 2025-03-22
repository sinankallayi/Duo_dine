import 'package:get/get.dart';
import 'package:restro_admin/app/data/constants.dart';
import 'package:restro_admin/app/data/models/restaurant_model.dart';

class HomeController extends GetxController {
  RxList<Restaurant> restaurants = <Restaurant>[].obs;
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  @override
  Future<void> onReady() async {
    await loadRestaurants();
  }

  Future<void> loadRestaurants() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      var result = await databases.listDocuments(
          databaseId: dbId, collectionId: restaurantCollection);
      restaurants.value =
          result.documents.map((e) => Restaurant.fromJson(e.data)).toList();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load restaurants: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> approve(String docId) async {
    try {
      isLoading.value = true;
      await databases.updateDocument(
          databaseId: dbId,
          collectionId: restaurantCollection,
          documentId: docId,
          data: {'approved': true});
      Get.snackbar('Success', 'Restaurant approved successfully');
      await loadRestaurants();
    } catch (e) {
      Get.snackbar('Error', 'Failed to approve restaurant: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> reject(String docId) async {
    try {
      isLoading.value = true;
      await databases.updateDocument(
          databaseId: dbId,
          collectionId: restaurantCollection,
          documentId: docId,
          data: {'approved': false});
      Get.snackbar('Success', 'Restaurant rejected successfully');
      await loadRestaurants();
    } catch (e) {
      Get.snackbar('Error', 'Failed to reject restaurant: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshRestaurants() async {
    await loadRestaurants();
  }

  void delete(String id) {
    Get.defaultDialog(
      title: 'Delete Restaurant',
      middleText: 'Are you sure you want to delete this restaurant?',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Get.theme.colorScheme.error,
      onConfirm: () async {
        try {
          isLoading.value = true;
          await databases.deleteDocument(
              databaseId: dbId,
              collectionId: restaurantCollection,
              documentId: id);
          Get.back();
          Get.snackbar('Success', 'Restaurant deleted successfully');
          await loadRestaurants();
        } catch (e) {
          Get.snackbar('Error', 'Failed to delete restaurant: ${e.toString()}');
        } finally {
          isLoading.value = false;
        }
      },
    );
  }
}
