import 'package:flutter/material.dart';
import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/screens/details/details_controller.dart';
import 'package:get/get.dart';

import '../../components/cards/item_card.dart';
import '../addToOrder/add_to_order_screen.dart';

class FavoritesScreen extends GetView<DetailsController> {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DetailsController());
    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Items")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final favoriteItems = controller.favoriteItems;

        if (favoriteItems.isEmpty) {
          return const Center(child: Text("No favorites yet!"));
        }

        return ListView.builder(
          itemCount: favoriteItems.length,
          itemBuilder: (context, index) {
            final item = favoriteItems[index];

            return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding, vertical: defaultPadding / 2),
                    child: ItemCard(
                      title: item.name,
                      description: item.description,
                      image: getImageUrl(item.imageId),
                      foodType: item.category,
                      price: item.price,
                      press: () => Get.to(() => AddToOrderScrreen(item: item)),
                      isFavorite: item.isFavorite,
                      onFavoritePressed: () => controller.toggleFavorite(item.$id),
                    ),
                  );
          },
        );
      }),
    );
  }
}
