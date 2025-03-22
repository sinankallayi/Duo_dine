import 'package:flutter/material.dart';
import 'package:foodly_ui/models/menu_items_model.dart';

import '../../../constants.dart';

class Info extends StatelessWidget {
  final MenuItemModel item;
  const Info({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1.33,
          child: Image.network(
            // "https://cloud.appwrite.io/v1/storage/buckets/$itemsBucketId/files/${item.imageId}/view?project=restro",
            getImageUrl(item.imageId),
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: defaultPadding),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.name,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                item.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              // const PriceRangeAndFoodtype(
              //   foodType: ["Chinese", "American", "Deshi food"],
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
