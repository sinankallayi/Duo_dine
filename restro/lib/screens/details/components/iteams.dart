import 'package:flutter/material.dart';
import 'package:foodly_ui/screens/details/details_controller.dart';
import 'package:get/get.dart';
import '../../../components/cards/iteam_card.dart';
import '../../../constants.dart';
import '../../addToOrder/add_to_order_screen.dart';

class Items extends GetView<DetailsController> {
  const Items({
    super.key,
    required,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
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
          
          if (controller.items.isEmpty)
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
            ...List.generate(
              controller.items.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: defaultPadding / 2),
                child: Obx(() => ItemCard(
                      title: controller.items[index].name,
                      description: controller.items[index].description,
                      // controller.items[index].imageId
                      // image: "https://cloud.appwrite.io/v1/storage/buckets/$itemsBucketId/files/${controller.items[index].imageId}/view?project=restro",
                      image: getImageUrl(controller.items[index].imageId),
                      foodType: controller.items[index].category,
                      price: controller.items[index].price,
                      press: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddToOrderScrreen(item: controller.items[index]),
                        ),
                      );
                      },
                    )),
              ),
            ),
        ],
      ),
    );
  }
}

