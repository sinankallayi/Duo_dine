import 'package:foodly_ui/models/delivery_person_model.dart';
import 'package:foodly_ui/models/menu_items_model.dart';
import 'package:foodly_ui/models/order_model.dart';
import 'package:foodly_ui/models/restaurant_model.dart';

class OrderItemsModel {
  String $id;
  MenuItemModel items;
  int qty;
  OrderModel orders;
  String status;
  DeliveryPersonModel? deliveryPerson;
  Restaurant restaurant;

  OrderItemsModel({
    required this.$id,
    required this.items,
    required this.qty,
    required this.orders,
    required this.status,
    required this.deliveryPerson,
    required this.restaurant,
  });

  // from json
  factory OrderItemsModel.fromJson(Map<String, dynamic> json) {
    return OrderItemsModel(
      $id: json['\$id'],
      items: MenuItemModel.fromJson(json['items']),
      qty: json['qty'],
      orders: OrderModel.fromJson(json['orders']),
      status: json['status'],
      deliveryPerson: json['deliveryPerson'] != null
          ? DeliveryPersonModel.fromJson(json['deliveryPerson'])
          : null,
      restaurant: Restaurant.fromJson(json['restaurant']),
    );
  }
}
