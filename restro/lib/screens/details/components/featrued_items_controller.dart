import 'package:foodly_ui/models/menu_items_model.dart';
import 'package:foodly_ui/services/db_service.dart';
import 'package:get/get.dart';

class FeaturedItemsController extends GetxController {
  final isLoading = true.obs;
  RxList<MenuItemModel> featuredItems = <MenuItemModel>[].obs;
  final DbService db = DbService();

  @override
  void onReady() async {
    loadFeatured();
    super.onReady();
  }

  Future<void> loadFeatured() async {
      isLoading.value = true;
      try {
        var featuredIds = await db.getFeaturedItemIds();
        final fetchedItems = await db.getAvailableItemsByIds(featuredIds);
        featuredItems.assignAll(fetchedItems);
        print('Featured Items loaded: ${featuredItems.length}');
      } catch (e) {
        print('Error loading featured items: $e');
      }
      isLoading.value = false;
  }
}
