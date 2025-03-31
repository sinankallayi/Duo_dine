import 'package:get/get.dart';

import '../data.dart';
import '../services/db_service.dart';

class FavoritesController extends GetxController {
  var favoriteItemIds = <String>[].obs;
  final DbService _appwriteService = DbService();
  String? userId;

  @override
  void onInit() async {
    userId = user?.$id; // await _appwriteService.getUserId();

    if (userId != null) {
      fetchFavorites();
      // _listenToFavorites();
    }
    super.onInit();
  }

  // void _listenToFavorites() {
  //   _appwriteService.realtime
  //       .subscribe(['databases.$dbId.collections.favorites.documents'])
  //       .stream
  //       .listen((event) {
  //         fetchFavorites();
  //       });
  // }

  void fetchFavorites() async {
    if (userId != null) {
      favoriteItemIds.assignAll(await _appwriteService.getUserFavoriteItemIds(userId!));
    }
  }

  void toggleFavorite(String itemId) async {
    if (userId == null) return;
    bool isFavorite = favoriteItemIds.contains(itemId);
    if (isFavorite) {
      favoriteItemIds.remove(itemId);
    } else {
      favoriteItemIds.add(itemId);
    }
    await _appwriteService.toggleFavorite(userId!, itemId, isFavorite);
  }
}
