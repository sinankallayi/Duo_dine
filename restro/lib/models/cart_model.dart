import 'package:foodly_ui/models/menu_items_model.dart';

class CartModel {
  final String $id;
  final MenuItemModel item;
  final int quantity;

  const CartModel({
    required this.$id,
    required this.item,
    required this.quantity,
  });

  // Convert to JSON for Appwrite
  Map<String, dynamic> toJson() {
    return {
      'items': item.$id, // Store only the item ID
      'quantity': quantity,
    };
  }

  // Convert from JSON from Appwrite
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      $id: json['\$id'],
      item:
          MenuItemModel.fromJson(json['items']), // Ensure relationship mapping
      quantity: json['quantity'],
    );
  }
}
