import 'package:flutter/material.dart';
import 'package:foodly_ui/models/enums/order_status.dart';
import 'package:foodly_ui/screens/orderDetails/order_timeline/timeline_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timelines_plus/timelines_plus.dart';

class TimelineScreen extends GetView<TimelineController> {
  const TimelineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(TimelineController());
    controller.item = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Timeline',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "₹${controller.item!.items.price * controller.item!.qty}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.green,
              ),
            ),
          ).paddingOnly(right: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item Details Section
                Text(
                  controller.item!.items.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.shopping_bag, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      'Qty: ${controller.item!.qty}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.description, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Description: ${controller.item!.items.description}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.restaurant, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Restaurant: ${controller.item!.items.restaurant.name}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),

                // Enhanced Timeline
                FixedTimeline.tileBuilder(
                  theme: TimelineThemeData(
                    nodePosition: 0,
                    direction: Axis.vertical,
                    connectorTheme: const ConnectorThemeData(
                      space: 8.0,
                      thickness: 3.0,
                    ),
                    indicatorTheme: const IndicatorThemeData(
                      size: 24.0,
                    ),
                  ),
                  builder: TimelineTileBuilder.connected(
                    itemCount: controller.orderTimeline.length,
                    contentsBuilder: (context, index) {
                      final item = controller.orderTimeline[index];
                      return Padding(
                        padding:
                            const EdgeInsets.only(left: 16.0, bottom: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  item.isCompleted
                                      ? Icons.check_circle
                                      : Icons.pending,
                                  color: item.isCompleted
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  item.status.statusText,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            if (item.createdDate != null)
                              Text(
                                DateFormat('dd MMM yyyy h:mm a')
                                    .format(item.createdDate!),
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                    indicatorBuilder: (context, index) {
                      final item = controller.orderTimeline[index];
                      return DotIndicator(
                        color: item.isCompleted ? Colors.green : Colors.grey,
                        child: item.isCompleted
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 12,
                              )
                            : null,
                      );
                    },
                    connectorBuilder: (context, index, type) {
                      final item = controller.orderTimeline[index];
                      if (item.isCompleted) {
                        return const SolidLineConnector(
                          color: Colors.green,
                        );
                      }
                      return const DashedLineConnector(
                        color: Colors.grey,
                      );
                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
