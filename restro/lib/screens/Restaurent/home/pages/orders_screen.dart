import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
          child: controller.orderItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/Illustrations/no_data.svg', height: 100),
                      const SizedBox(height: 10),
                      const Text('No orders Found', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: controller.orderItems.length,
                  itemBuilder: (context, index) {
                    final orderItem = controller.orderItems[index].obs;
                    return Obx(
                      () => OrderItemCard(
                          orderItem: orderItem.value,
                          assignDeliveryPerson: (OrderItemsModel orderItem) {
                            controller.showDeliveryPersons(orderItem);
                          },
                          updateOrderStatus:
                              (OrderItemsModel orderItem, OrderStatus nextStatus) async {
                            print("updating order status to ${nextStatus.value}");
                            await controller.updateOrderStatus(orderItem, nextStatus);
                          },
                          updateDeliveryPersonStatus:
                              (OrderItemsModel orderItem, DeliveryStatus nextStatus) async {
                            print("updating order status to ${nextStatus.value}");
                            await controller.updateDeliveryPersonStatus(orderItem, nextStatus);
                          }),
                    );
                  },
                ),
        );
      }),
    ).paddingSymmetric(horizontal: defaultPadding);
  }
}
