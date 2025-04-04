import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restro_delivery/app/data/enums/order_status.dart';
import 'package:url_launcher/url_launcher.dart';

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
          controller.getOrders();
        },
        child:
            controller.orderItemsModel.isEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('No orders available'),

                      TextButton.icon(
                        onPressed: () {
                          controller.getOrders();
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
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap:
                                  () => Get.to(
                                    () => OrderDetailView(orderItemsModel: orderItemsModel),
                                  ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      orderItemsModel.items.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Delivery Status: ${orderItemsModel.deliveryPerson?.deliveryStatus.statusText}',
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                    if (orderItemsModel.address?.isNotEmpty == true) ...[
                                      const SizedBox(height: 6),
                                      Text(
                                        "Address: ${orderItemsModel.address}",
                                        style: const TextStyle(color: Colors.grey),
                                      ),
                                      const SizedBox(height: 4),
                                      MapButton(address: orderItemsModel.address!),
                                    ],
                                    const SizedBox(height: 12),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        orderItemsModel.status.statusText,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 10,
                              runSpacing: 10,
                              children:
                                  deliveryStatus.actions.map((action) {
                                    if (orderItemsModel.isPreparingFood() &&
                                        action.nextStatus == DeliveryStatus.orderPickedUp) {
                                      return const SizedBox.shrink();
                                    }
                                    return ElevatedButton.icon(
                                      onPressed: () async {
                                        await controller.changeStatus(
                                          orderItemsModel,
                                          action.nextStatus,
                                        );
                                        action.onTap(orderItemsModel);
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

class MapButton extends StatelessWidget {
  final String address;

  const MapButton({super.key, required this.address});

  Future<void> openMapWithAddress(String address) async {
    final query = Uri.encodeComponent(address);
    final googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$query';

    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => openMapWithAddress(address),
      icon: const Icon(Icons.map, color: Colors.blue),
      label: const Text(
        'Open in Maps',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.blue),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),
    );
  }
}
