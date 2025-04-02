import 'package:flutter/material.dart';

import '../../../constants.dart';

class FeaturedItemCard extends StatelessWidget {
  const FeaturedItemCard({
    super.key,
    required this.foodType,
    required this.image,
    required this.press,
    required this.title,
    required this.restaurantName,
  });

  final String foodType, image, title, restaurantName;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.labelLarge!.copyWith(
          color: titleColor.withAlpha(120),
          fontWeight: FontWeight.normal,
        );
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          width: 140,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: titleColor, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(foodType, style: textStyle),
                  Row(
                    children: [
                      Icon(Icons.food_bank_rounded, size: 16, color: primaryColor.withAlpha(120)),
                      const SizedBox(width: 4),
                      Text(restaurantName, style: textStyle),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
