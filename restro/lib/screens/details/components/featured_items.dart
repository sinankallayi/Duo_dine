import 'package:flutter/material.dart';
import 'package:foodly_ui/screens/details/details_controller.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import 'featured_item_card.dart';

class FeaturedItems extends GetView<DetailsController> {
  const FeaturedItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.featuredItems.isEmpty) {
        return const SizedBox.shrink();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Text("Featured Items",
                style: Theme.of(context).textTheme.titleLarge),
          ),
          const SizedBox(height: defaultPadding / 2),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...List.generate(
                  controller.featuredItems.length, // for demo we use 3
                  (index) => Padding(
                    padding: const EdgeInsets.only(left: defaultPadding),
                    child: FeaturedItemCard(
                      title: controller.featuredItems[index].name,
                      // image: "https://cloud.appwrite.io/v1/storage/buckets/$itemsBucketId/files/${controller.featuredItems[index].imageId}/view?project=restro",
                      image: getImageUrl(controller.featuredItems[index].imageId),
                      foodType: controller.featuredItems[index].category,
                      press: () {},
                    ),
                  ),
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
