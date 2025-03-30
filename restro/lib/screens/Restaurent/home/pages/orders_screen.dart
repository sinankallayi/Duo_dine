import 'package:flutter/material.dart';
import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/models/order_items_model.dart';
import 'package:foodly_ui/screens/Restaurent/home/controllers/orders_controller.dart';
import 'package:get/get.dart';

import '../../../../models/enums/delivery_status.dart';
import '../../../../models/enums/order_status.dart';
import 'order_item_view.dart';

class OrdersScreen extends GetView<OrdersController> {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: () async {
            controller.getOrders();
          },
          child: ListView.builder(
            itemCount: controller.orderItems.length,
            itemBuilder: (context, index) {
              final orderItem = controller.orderItems[index].obs;
              return Obx(
                () => OrderItemCard(
                    orderItem: orderItem.value,
                    assignDeliveryPerson: (OrderItemsModel orderItem) {
                      controller.showDeliveryPersons(orderItem);
                    },
                    updateOrderStatus: (OrderItemsModel orderItem, OrderStatus nextStatus) {
                      print("updating order status to ${nextStatus.value}");
                      controller.updateOrderStatus(orderItem, nextStatus);
                    },
                    updateDeliveryPersonStatus:
                        (OrderItemsModel orderItem, DeliveryStatus nextStatus) {
                      print("updating order status to ${nextStatus.value}");
                      controller.updateDeliveryPersonStatus(orderItem, nextStatus);
                    }),
              );
            },
          ),
        );
      }),
    ).paddingSymmetric(horizontal: defaultPadding);
  }
}
