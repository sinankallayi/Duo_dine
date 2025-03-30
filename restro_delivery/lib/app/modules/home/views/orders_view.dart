import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restro_delivery/app/data/enums/order_status.dart';

import '../../../data/enums/delivery_status.dart';
import '../controllers/home_controller.dart';
import 'order_detail_view.dart';

class OrdersView extends GetView<HomeController> {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return RefreshIndicator(
        onRefresh: () async {
          controller.loadOrders();
        },
        child:
            controller.orderItemsModel.isEmpty
                ? Center(
                  child: Column(
                    children: [
                      Text('No orders available'),

                      TextButton.icon(
                        onPressed: () {
                          controller.loadOrders();
                        },
                        icon: Icon(Icons.refresh),
                        label: Text('Refresh'),
                        style: ButtonStyle(
                          iconColor: WidgetStateProperty.all(Colors.blue),
                          foregroundColor: WidgetStateProperty.all(Colors.blue),
                        ),
                      ),
                    ],
                  ),
                )
                : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: controller.orderItemsModel.length,
                  itemBuilder: (context, index) {
                    final orderItemsModel = controller.orderItemsModel[index];
                    final deliveryPerson = orderItemsModel.deliveryPerson;
                    if (deliveryPerson == null) {
                      return const SizedBox.shrink();
                    }
                    final DeliveryStatus deliveryStatus = deliveryPerson.deliveryStatus;
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              orderItemsModel.items.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Delivery Status: ${orderItemsModel.deliveryPerson?.deliveryStatus.statusText}',
                            ),
                            trailing: Text(orderItemsModel.status.statusText),
                            onTap: () {
                              Get.to(() => OrderDetailView(orderItemsModel: orderItemsModel));
                            },
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 10,
                              runSpacing: 10,
                              children:
                                  deliveryStatus.actions.map((action) {
                                    return ElevatedButton.icon(
                                      onPressed: () {
                                        action.onTap(orderItemsModel);
                                        controller.changeStatus(orderItemsModel, action.nextStatus);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: action.color,
                                      ),
                                      icon: Icon(action.icon, color: action.color),
                                      label: Text(action.label),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
      );
    });
  }
}
