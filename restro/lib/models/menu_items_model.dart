import 'package:foodly_ui/models/restaurant_model.dart';

class MenuItemModel {
  String name;
  String description;
  double price;
  bool availability;
  bool? featured;
  double rating;
  Restaurant restaurant;
  String category;
  String imageId;
  String $id;
  DateTime createdAt;
  DateTime updatedAt;
  bool isFavorite = false;

  MenuItemModel({
    required this.name,
    required this.description,
    required this.price,
    this.availability = true,
    this.rating = 0.0,
    this.featured,
    required this.restaurant,
    required this.category,
    required this.imageId,
    required this.$id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      availability: json['availability'] ?? true,
      rating: json['rating']?.toDouble() ?? 0.0,
      restaurant: Restaurant.fromJson(json['restaurant']),
      category: json['category'] ?? '',
      imageId: json['imageId'] ?? '',
      featured: json['featured'] ?? false,
      $id: json['\$id'],
      createdAt: DateTime.parse(json['\$createdAt']),
      updatedAt: DateTime.parse(json['\$updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'availability': availability,
      'rating': rating,
      'restaurant': restaurant,
      'category': category,
      'imageId': imageId,
      '\$id': $id,
      '\$createdAt': createdAt.toIso8601String(),
      '\$updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'MenuItemModel(name: $name, category: $category, price: $price, available: $availability)';
  }
}
