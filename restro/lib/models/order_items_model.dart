import 'package:flutter/material.dart';
import 'package:foodly_ui/models/delivery_person_model.dart';
import 'package:foodly_ui/models/enums/order_status.dart';
import 'package:foodly_ui/models/menu_items_model.dart';
import 'package:foodly_ui/models/order_model.dart';
import 'package:foodly_ui/models/restaurant_model.dart';
import 'package:get/get.dart';

import 'enums/delivery_status.dart';

class OrderItemsModel {
  String $id;
  MenuItemModel items;
  int qty;
  OrderModel orders;
  OrderStatus status;
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
      status: OrderStatusExtension.fromString(json['status']),
      deliveryPerson: json['deliveryPerson'] != null
          ? DeliveryPersonModel.fromJson(json['deliveryPerson'])
          : null,
      restaurant: Restaurant.fromJson(json['restaurant']),
    );
  }

  bool isCooking() {
    return [
      OrderStatus.orderConfirmed,
      OrderStatus.foodPreparing,
      OrderStatus.foodReadyForPickup,
    ].contains(status);
  }

  bool isConfirmedButNotAssigned() {
    return isCooking() && deliveryPerson == null;
  }

  bool isRejectedOrNoAction() {
    return isCooking() &&
        deliveryPerson != null &&
        [
          DeliveryStatus.newOrderAssigned,
          DeliveryStatus.rejectedOrder,
          DeliveryStatus.acceptedOrder
        ].contains(deliveryPerson?.deliveryStatus);
  }

  bool isWaitingForDriver() {
    return OrderStatus.foodReadyForPickup == status &&
        deliveryPerson?.deliveryStatus != DeliveryStatus.arrivedAtRestaurant;
  }

  bool isDelivering() {
    return deliveryPerson?.deliveryStatus !=
        [
          DeliveryStatus.headingToRestaurant,
          DeliveryStatus.arrivedAtRestaurant,
          DeliveryStatus.orderPickedUp,
          DeliveryStatus.headingToCustomer,
          DeliveryStatus.arrivedAtCustomer,
          DeliveryStatus.delivered,
          DeliveryStatus.orderCanceled,
          DeliveryStatus.customerUnreachable,
          DeliveryStatus.deliveryFailed,
          DeliveryStatus.returnedToRestaurant,
        ].contains(status);
  }

  DeliveryAction get assignDriver => DeliveryAction(
        label: "Assign Driver",
        onTap: (OrderItemsModel orderItem) => Get.snackbar(
            orderItem.items.name, "Assigned to Delivery Person",
            colorText: Colors.blue),
        color: Colors.blue,
        icon: Icons.delivery_dining,
        nextStatus: DeliveryStatus.newOrderAssigned,
      );

  DeliveryAction get changeDriver => DeliveryAction(
        label: "Change Driver",
        onTap: (OrderItemsModel orderItem) =>
            Get.snackbar(orderItem.items.name, "Changed Delivery Person", colorText: Colors.blue),
        color: Colors.orange,
        icon: Icons.delivery_dining,
        nextStatus: DeliveryStatus.newOrderAssigned,
      );
}
