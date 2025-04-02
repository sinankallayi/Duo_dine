import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/section_title.dart';
import '../../../constants.dart';
import '../../addToOrder/add_to_order_screen.dart';
import 'featrued_items_controller.dart';
import 'featured_item_card.dart';

class FeaturedItems extends GetView<FeaturedItemsController> {
  const FeaturedItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(FeaturedItemsController());
    return Obx(() {
      if (controller.featuredItems.isEmpty) {
        return const SizedBox.shrink();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
              title: "Featured",
              press: () {
                controller.loadFeatured();
              }),
          const SizedBox(height: defaultPadding / 2),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...List.generate(
                  controller.featuredItems.length,
                  (index) {
                    var item = controller.featuredItems[index];
                    return Padding(
                      padding: const EdgeInsets.only(left: defaultPadding),
                      child: FeaturedItemCard(
                        title: item.name,
                        image: getImageUrl(item.imageId),
                        foodType: item.category,
                        restaurantName: item.restaurant.name,
                        press: () => Get.to(() => AddToOrderScrreen(item: item)),
                      ),
                    );
                  },
                ),
                const SizedBox(width: defaultPadding),
              ],
            ),
          ),
        ],
      );
    });
  }
}
