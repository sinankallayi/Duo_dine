import 'package:flutter/material.dart';
import 'package:foodly_ui/models/enums/order_status.dart';
import 'package:foodly_ui/models/order_items_model.dart';
import 'package:intl/intl.dart';

import '/constants.dart';
import '../../../../models/enums/delivery_status.dart';

class OrderItemCard extends StatelessWidget {
  final OrderItemsModel orderItem;
  final Function(OrderItemsModel orderItem) assignDeliveryPerson;
  final Function(OrderItemsModel orderItem, OrderStatus nextStatus) updateOrderStatus;
  final Function(OrderItemsModel orderItem, DeliveryStatus nextStatus) updateDeliveryPersonStatus;

  const OrderItemCard({
    super.key,
    required this.orderItem,
    required this.assignDeliveryPerson,
    required this.updateOrderStatus,
    required this.updateDeliveryPersonStatus,
  });

  @override
  Widget build(BuildContext context) {
    final orderItemStatus = orderItem.status;
    var deliveryStatus = orderItem.deliveryPerson?.deliveryStatus.statusText;
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        orderItem.items.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        DateFormat("MMM d, yyyy hh:MM a").format(orderItem.orders.createdDate),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          Text(
                            orderItem.deliveryPerson?.name ?? "Not Assigned",
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          if (deliveryStatus != null)
                            Text(
                              deliveryStatus,
                              style: const TextStyle(fontSize: 12),
                            ),
                        ],
                      ),
                      Text(
                        orderItem.status.statusText,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    // Price
                    Text(
                      "₹${(orderItem.items.price * orderItem.qty).toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor),
                    ),

                    //Quantity
                    Container(
                      height: 30,
                      width: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: primaryColor.withAlpha(20),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: primaryColor.withAlpha(60)),
                      ),
                      child: Text(
                        orderItem.qty.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Complaints section (if any)
            if (orderItem.orders.complaints != null &&
                orderItem.orders.complaints.toString().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 18),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "${orderItem.orders.complaints}",
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                spacing: 10,
                children: [
                  ...orderItemStatus.actions.map((action) {
                    if (orderItem.isConfirmedButNotAssigned() || orderItem.isWaitingForDriver()) {
                      return const SizedBox.shrink();
                    }
                    return ActionButton(
                      onPressed: () {
                        action.onTap(orderItem);
                        updateOrderStatus(orderItem, action.nextStatus);
                      },
                      iconColor: action.color,
                      icon: action.icon,
                      label: action.label,
                      buttonColor: Colors.white,
                      borderColor: action.color,
                    );
                  }),
                  if (orderItem.isConfirmedButNotAssigned())
                    ActionButton(
                      onPressed: () {
                        assignDeliveryPerson(orderItem);
                      },
                      iconColor: orderItem.assignDriver.color,
                      icon: orderItem.assignDriver.icon,
                      label: orderItem.assignDriver.label,
                      buttonColor: Colors.white,
                      borderColor: orderItem.assignDriver.color,
                    ),
                  if (orderItem.isRejectedOrNoAction())
                    ActionButton(
                      onPressed: () {
                        assignDeliveryPerson(orderItem);
                      },
                      iconColor: orderItem.changeDriver.color,
                      icon: orderItem.changeDriver.icon,
                      label: orderItem.changeDriver.label,
                      buttonColor: Colors.white,
                      borderColor: orderItem.changeDriver.color,
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded ActionButton({
    required void Function() onPressed,
    required Color iconColor,
    required IconData icon,
    required String label,
    required Color buttonColor,
    required Color borderColor,
  }) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: iconColor,
          backgroundColor: buttonColor,
          padding: const EdgeInsets.symmetric(vertical: 10),
          disabledBackgroundColor: Colors.grey.withAlpha(60),
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: borderColor, width: 2),
          ),
        ),
        icon: Icon(icon, color: iconColor),
        label: Text(label),
      ),
    );
  }
}
