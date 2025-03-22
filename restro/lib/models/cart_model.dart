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

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'items': item.toJson(),
      'quantity': quantity,
    };
  }

  // fromJson
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      $id: json['\$id'],
      item: MenuItemModel.fromJson(json['items']),
      quantity: json['quantity'],
    );
  }
}
