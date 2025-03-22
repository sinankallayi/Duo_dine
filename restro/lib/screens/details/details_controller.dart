import 'package:appwrite/appwrite.dart';
import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/models/menu_items_model.dart';
import 'package:foodly_ui/models/restaurant_model.dart';
import 'package:get/get.dart';

class DetailsController extends GetxController {
  final isLoading = true.obs;
  Restaurant? restaurant;
  RxList<MenuItemModel> items = <MenuItemModel>[].obs;
  RxList<MenuItemModel> featuredItems = <MenuItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    // load items
    try {
      final response = await db.listDocuments(
          databaseId: dbId,
          collectionId: itemsCollection,
          queries: [Query.equal("restaurant", restaurant!.id)]);

      final fetchedItems = response.documents
          .map((doc) => MenuItemModel.fromJson(doc.data))
          .toList();
      items.addAll(fetchedItems);
      featuredItems
          .addAll(fetchedItems.where((item) => item.featured!).toList());

      print('Items loaded: ${items.length}');
    } catch (e) {
      print('Error loading items: $e');
    } finally {
      isLoading.value = false;
    }
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
