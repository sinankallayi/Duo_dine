import 'package:flutter/material.dart';
import 'package:foodly_ui/models/menu_items_model.dart';
import 'package:foodly_ui/screens/details/details_controller.dart';
import 'package:get/get.dart';

import '../../../components/cards/item_card.dart';
import '../../../constants.dart';
import '../../addToOrder/add_to_order_screen.dart';

class Items extends GetView<DetailsController> {
  const Items({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final items = controller.items;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding / 2),
              child: Text(
                "Items",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            if (items.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Text(
                    "No items available",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
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
              ),
          ],
        );
      },
    );
  }
}
