import 'package:foodly_ui/models/menu_items_model.dart';
import 'package:foodly_ui/models/restaurant_model.dart';
import 'package:foodly_ui/services/db_service.dart';
import 'package:get/get.dart';

import '../../controllers/favorites_controller.dart';
import '../../data.dart';

class DetailsController extends GetxController {
  final isLoading = true.obs;
  Restaurant? restaurant;
  RxList<MenuItemModel> items = <MenuItemModel>[].obs;
  RxList<MenuItemModel> favoriteItems = <MenuItemModel>[].obs;
  RxList<MenuItemModel> featuredItems = <MenuItemModel>[].obs;
  final DbService db = DbService();
  final FavoritesController _favoritesController = Get.put(FavoritesController());
  String? userId;

  @override
  void onReady() async {
    await loadItems();
    userId = user?.$id;
    if (userId != null) {
      await loadFavorites();
    }
    super.onReady();
  }

  Future<void> loadItems() async {
    isLoading.value = true;
    try {
      final fetchedItems = await db.getAvailableItemsForRestaurant(restaurant!.id);
      items.assignAll(fetchedItems);
      updateFavoriteStatus(items);
      // featuredItems.assignAll(fetchedItems.where((item) => item.featured!).toList());
      // updateFavoriteStatus(featuredItems);

      print('Items loaded: ${items.length}');
    } catch (e) {
      print('Error loading items: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadFavorites() async {
    if (userId != null) {
      isLoading.value = true;
      try {
        var favs = await db.getUserFavoriteItemIds(userId!);
        final fetchedItems = await db.getAvailableItemsByIds(favs);
        favoriteItems.assignAll(fetchedItems);
        updateFavoriteStatus(favoriteItems);

        print('Items loaded: ${items.length}');
      } catch (e) {
        print('Error loading items: $e');
      }
      isLoading.value = false;
    }
  }

  void updateFavoriteStatus(items) {
    for (var item in items) {
      item.isFavorite = _favoritesController.favoriteItemIds.contains(item.$id);
    }
    items.refresh();
  }

  void toggleFavorite(itemId) async {
    _favoritesController.toggleFavorite(itemId);
    await loadItems();
    await loadFavorites();
  }
}
