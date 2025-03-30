import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../order_items_model.dart';

enum OrderStatus {
  orderPlaced,
  orderConfirmed,
  foodPreparing,
  foodReadyForPickup,
  outForDelivery,
  foodDelivered,
  orderCompleted,
  orderCancelled,
  orderFailed,
  refunded,
  returned,
}

// Class representing an order action (button)
class OrderAction {
  final String label;
  final Function(OrderItemsModel) onTap;
  final Color color;
  final IconData icon;
  final OrderStatus nextStatus; // New field for next status

  OrderAction({
    required this.label,
    required this.onTap,
    required this.color,
    required this.icon,
    required this.nextStatus, // Nullable, since some actions (like Cancel) may not have a next status.
  });
}

extension OrderStatusExtension on OrderStatus {
  String get value => toString().split('.').last;

  String get statusText {
    switch (this) {
      case OrderStatus.orderPlaced:
        return 'Order Placed';
      case OrderStatus.orderConfirmed:
        return 'Order Confirmed';
      case OrderStatus.foodPreparing:
        return 'Food Preparing';
      case OrderStatus.foodReadyForPickup:
        return 'Food Ready for Pickup';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.foodDelivered:
        return 'Food Delivered';
      case OrderStatus.orderCompleted:
        return 'Order Completed';
      case OrderStatus.orderCancelled:
        return 'Order Cancelled';
      case OrderStatus.orderFailed:
        return 'Order Failed';
      case OrderStatus.refunded:
        return 'Refunded';
      case OrderStatus.returned:
        return 'Returned';
    }
  }

  List<OrderAction> get actions {
    switch (this) {
      case OrderStatus.orderPlaced:
        return [
          OrderAction(
              label: "Confirm Order",
              onTap: (OrderItemsModel orderItem) =>
                  Get.snackbar(orderItem.items.name, "Order Confirmed", colorText: Colors.green),
              color: Colors.green,
              icon: Icons.check,
              nextStatus: OrderStatus.orderConfirmed),
          OrderAction(
              label: "Cancel Order",
              onTap: (OrderItemsModel orderItem) =>
                  Get.snackbar(orderItem.items.name, "Order Cancelled", colorText: Colors.red),
              color: Colors.red,
              icon: Icons.cancel,
              nextStatus: OrderStatus.orderCancelled),
        ];
      case OrderStatus.orderConfirmed:
        return [
          OrderAction(
              label: "Start Preparing",
              onTap: (OrderItemsModel orderItem) => Get.snackbar(
                  orderItem.items.name, "Food is being prepared",
                  colorText: Colors.orange),
              color: Colors.orange,
              icon: Icons.kitchen,
              nextStatus: OrderStatus.foodPreparing),
        ];
      case OrderStatus.foodPreparing:
        return [
          OrderAction(
              label: "Mark as Ready",
              onTap: (OrderItemsModel orderItem) => Get.snackbar(
                  orderItem.items.name, "Food Ready for Pickup",
                  colorText: Colors.blue),
              color: Colors.blue,
              icon: Icons.fastfood,
              nextStatus: OrderStatus.foodReadyForPickup),
        ];
      case OrderStatus.foodReadyForPickup:
        return [
          OrderAction(
              label: "Out for Delivery",
              onTap: (OrderItemsModel orderItem) =>
                  Get.snackbar(orderItem.items.name, "Out for Delivery", colorText: Colors.orange),
              color: Colors.orange,
              icon: Icons.delivery_dining,
              nextStatus: OrderStatus.outForDelivery),
        ];
      case OrderStatus.outForDelivery:
        return [
          OrderAction(
              label: "Mark as Delivered",
              onTap: (OrderItemsModel orderItem) =>
                  Get.snackbar(orderItem.items.name, "Food Delivered", colorText: Colors.green),
              color: Colors.green,
              icon: Icons.home,
              nextStatus: OrderStatus.foodDelivered),
          OrderAction(
              label: "Mark as Failed",
              onTap: (OrderItemsModel orderItem) =>
                  Get.snackbar(orderItem.items.name, "Delivery Failed", colorText: Colors.red),
              color: Colors.red,
              icon: Icons.error,
              nextStatus: OrderStatus.orderFailed),
        ];
      case OrderStatus.foodDelivered:
        return [
          OrderAction(
              label: "Complete Order",
              onTap: (OrderItemsModel orderItem) =>
                  Get.snackbar(orderItem.items.name, "Order Completed", colorText: Colors.green),
              color: Colors.green,
              icon: Icons.done,
              nextStatus: OrderStatus.orderCompleted),
        ];
      case OrderStatus.orderCancelled:
      case OrderStatus.orderFailed:
      case OrderStatus.refunded:
      case OrderStatus.returned:
      case OrderStatus.orderCompleted:
        return [];
    }
  }

  static OrderStatus fromString(String status) {
    return OrderStatus.values.firstWhere(
      (e) => e.value == status,
      orElse: () => OrderStatus.orderPlaced,
    );
  }
}
