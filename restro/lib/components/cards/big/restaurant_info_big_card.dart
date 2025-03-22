import 'package:flutter/material.dart';
// import 'big_card_image_slide.dart';

class RestaurantInfoBigCard extends StatelessWidget {
  final List<String> images;
  final String id, name, address, location, tags, description, phone;
  final bool approved;
  final double? rating;
  final DateTime createdAt, updatedAt;
  final VoidCallback press;

  const RestaurantInfoBigCard({
    super.key,
    required this.id,
    required this.name,
    required this.address,
    required this.location,
    required this.tags,
    required this.description,
    required this.approved,
    required this.phone,
    this.rating,
    required this.createdAt,
    required this.updatedAt,
    required this.images,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // pass list of images here
          // BigCardImageSlide(images: images),
          const SizedBox(height: 8), // replaced defaultPadding/2
          Text(name, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4), // replaced defaultPadding/4
          // New info: address
          Text(address, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 4),
          // New info: location and phone in a row
          Row(
            children: [
              Expanded(
                child: Text(location, style: Theme.of(context).textTheme.bodySmall),
              ),
              const SizedBox(width: 8),
              Text(phone, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 4),
          // New info: rating and tags row
          Row(
            children: [
              if (rating != null)
                Row(
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text("$rating", style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              const SizedBox(width: 16),
              Text(tags, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 4),
          // New info: description
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
