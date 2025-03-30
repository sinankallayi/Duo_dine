import 'package:flutter/material.dart';
import 'package:foodly_ui/models/order_items_model.dart';
import 'package:get/get.dart';

enum DeliveryStatus {
  offline,
  online,
  newOrderAssigned,
  acceptedOrder,
  rejectedOrder,
  headingToRestaurant,
  arrivedAtRestaurant,
  orderPickedUp,
  headingToCustomer,
  arrivedAtCustomer,
  delivered,
  orderCanceled,
  customerUnreachable,
  deliveryFailed,
  returnedToRestaurant,
}

// Class representing a delivery action (button)
class DeliveryAction {
  final String label;
  final Function(OrderItemsModel) onTap;
  final Color color;
  final IconData icon;
  final DeliveryStatus nextStatus;

  DeliveryAction({
    required this.label,
    required this.onTap,
    required this.color,
    required this.icon,
    required this.nextStatus,
  });
}

extension DeliveryStatusExtension on DeliveryStatus {
  String get value => toString().split('.').last;

  String get statusText {
    switch (this) {
      case DeliveryStatus.offline:
        return 'Offline';
      case DeliveryStatus.online:
        return 'Online';
      case DeliveryStatus.newOrderAssigned:
        return 'New Order Assigned';
      case DeliveryStatus.acceptedOrder:
        return 'Order Accepted';
      case DeliveryStatus.rejectedOrder:
        return 'Order Rejected';
      case DeliveryStatus.headingToRestaurant:
        return 'Heading to Restaurant';
      case DeliveryStatus.arrivedAtRestaurant:
        return 'Arrived at Restaurant';
      case DeliveryStatus.orderPickedUp:
        return 'Order Picked Up';
      case DeliveryStatus.headingToCustomer:
        return 'Heading to Customer';
      case DeliveryStatus.arrivedAtCustomer:
        return 'Arrived at Customer';
      case DeliveryStatus.delivered:
        return 'Delivered';
      case DeliveryStatus.orderCanceled:
        return 'Order Canceled';
      case DeliveryStatus.customerUnreachable:
        return 'Customer Unreachable';
      case DeliveryStatus.deliveryFailed:
        return 'Delivery Failed';
      case DeliveryStatus.returnedToRestaurant:
        return 'Returned to Restaurant';
    }
  }

  List<DeliveryAction> get actions {
    switch (this) {
      case DeliveryStatus.offline:
        return [
          DeliveryAction(
              label: "Go Online",
              onTap: (OrderItemsModel orderItem) => Get.snackbar(
                  orderItem.deliveryPerson?.name ?? orderItem.items.name, "Going Online",
                  colorText: Colors.green),
              color: Colors.green,
              icon: Icons.power,
              nextStatus: DeliveryStatus.online),
        ];
      case DeliveryStatus.online:
        return [
          DeliveryAction(
              label: "Wait for Orders",
              onTap: (OrderItemsModel orderItem) => Get.snackbar(
                  orderItem.deliveryPerson?.name ?? orderItem.items.name, "Waiting for Orders",
                  colorText: Colors.blue),
              color: Colors.blue,
              icon: Icons.access_time,
              nextStatus: DeliveryStatus.online),
        ];
      case DeliveryStatus.newOrderAssigned:
        return [
          DeliveryAction(
              label: "Accept Order",
              onTap: (OrderItemsModel orderItem) => Get.snackbar(
                  orderItem.deliveryPerson?.name ?? orderItem.items.name, "Order Accepted",
                  colorText: Colors.green),
              color: Colors.green,
              icon: Icons.check_circle,
              nextStatus: DeliveryStatus.acceptedOrder),
          DeliveryAction(
              label: "Reject Order",
              onTap: (OrderItemsModel orderItem) => Get.snackbar(
                  orderItem.deliveryPerson?.name ?? orderItem.items.name, "Order Rejected",
                  colorText: Colors.red),
              color: Colors.red,
              icon: Icons.cancel,
              nextStatus: DeliveryStatus.rejectedOrder),
        ];
      case DeliveryStatus.acceptedOrder:
        return [
          DeliveryAction(
              label: "Drive to Restaurant",
              onTap: (OrderItemsModel orderItem) => Get.snackbar(
                  orderItem.deliveryPerson?.name ?? orderItem.items.name, "Heading to Restaurant",
                  colorText: Colors.orange),
              color: Colors.orange,
              icon: Icons.restaurant,
              nextStatus: DeliveryStatus.headingToRestaurant),
        ];
      case DeliveryStatus.headingToRestaurant:
        return [
          DeliveryAction(
              label: "Arrived at Restaurant",
              onTap: (OrderItemsModel orderItem) => Get.snackbar(
                  orderItem.deliveryPerson?.name ?? orderItem.items.name, "Arrived at Restaurant",
                  colorText: Colors.blue),
              color: Colors.blue,
              icon: Icons.location_on,
              nextStatus: DeliveryStatus.arrivedAtRestaurant),
        ];
      case DeliveryStatus.arrivedAtRestaurant:
        return [
          DeliveryAction(
              label: "Pick Up Order",
              onTap: (OrderItemsModel orderItem) => Get.snackbar(
                  orderItem.deliveryPerson?.name ?? orderItem.items.name, "Order Picked Up",
                  colorText: Colors.green),
              color: Colors.green,
              icon: Icons.shopping_bag,
              nextStatus: DeliveryStatus.orderPickedUp),
        ];
      case DeliveryStatus.orderPickedUp:
        return [
          DeliveryAction(
              label: "Drive to Customer",
              onTap: (OrderItemsModel orderItem) => Get.snackbar(
                  orderItem.deliveryPerson?.name ?? orderItem.items.name, "Heading to Customer",
                  colorText: Colors.orange),
              color: Colors.orange,
              icon: Icons.directions_bike,
              nextStatus: DeliveryStatus.headingToCustomer),
        ];
      case DeliveryStatus.headingToCustomer:
        return [
          DeliveryAction(
              label: "Arrived at Customer",
              onTap: (OrderItemsModel orderItem) => Get.snackbar(
                  orderItem.deliveryPerson?.name ?? orderItem.items.name, "Arrived at Customer",
                  colorText: Colors.blue),
              color: Colors.blue,
              icon: Icons.home,
              nextStatus: DeliveryStatus.arrivedAtCustomer),
        ];
      case DeliveryStatus.arrivedAtCustomer:
        return [
          DeliveryAction(
              label: "Mark as Delivered",
              onTap: (OrderItemsModel orderItem) => Get.snackbar(
                  orderItem.deliveryPerson?.name ?? orderItem.items.name, "Order Delivered",
                  colorText: Colors.green),
              color: Colors.green,
              icon: Icons.done,
              nextStatus: DeliveryStatus.delivered),
          DeliveryAction(
              label: "Customer Unreachable",
              onTap: (OrderItemsModel orderItem) => Get.snackbar(
                  orderItem.deliveryPerson?.name ?? orderItem.items.name, "Customer Unreachable",
                  colorText: Colors.red),
              color: Colors.red,
              icon: Icons.person_off,
              nextStatus: DeliveryStatus.customerUnreachable),
        ];
      case DeliveryStatus.customerUnreachable:
        return [
          DeliveryAction(
              label: "Mark as Failed",
              onTap: (OrderItemsModel orderItem) => Get.snackbar(
                  orderItem.deliveryPerson?.name ?? orderItem.items.name, "Delivery Failed",
                  colorText: Colors.red),
              color: Colors.red,
              icon: Icons.error,
              nextStatus: DeliveryStatus.deliveryFailed),
          DeliveryAction(
              label: "Return to Restaurant",
              onTap: (OrderItemsModel orderItem) => Get.snackbar(
                  orderItem.deliveryPerson?.name ?? orderItem.items.name, "Returning to Restaurant",
                  colorText: Colors.orange),
              color: Colors.orange,
              icon: Icons.undo,
              nextStatus: DeliveryStatus.returnedToRestaurant),
        ];
      case DeliveryStatus.deliveryFailed:
        return [
          DeliveryAction(
              label: "Return to Restaurant",
              onTap: (OrderItemsModel orderItem) => Get.snackbar(
                  orderItem.deliveryPerson?.name ?? orderItem.items.name, "Returning to Restaurant",
                  colorText: Colors.orange),
              color: Colors.orange,
              icon: Icons.undo,
              nextStatus: DeliveryStatus.returnedToRestaurant),
        ];
      case DeliveryStatus.delivered:
      case DeliveryStatus.orderCanceled:
      case DeliveryStatus.rejectedOrder:
      case DeliveryStatus.returnedToRestaurant:
        return []; // No further actions
    }
  }

  static DeliveryStatus fromString(String status) {
    return DeliveryStatus.values.firstWhere(
      (e) => e.value == status,
      orElse: () => DeliveryStatus.online,
    );
  }
}
