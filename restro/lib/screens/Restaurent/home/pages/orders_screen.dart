import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/screens/Restaurent/home/controllers/orders_controller.dart';
import 'package:foodly_ui/screens/orderDetails/components/order_item_card.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
                () => Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: orderItem.value.status == "cooking"
                            ? null
                            : (context) {
                                controller.updateOrderStatus(
                                  orderItem.value.$id,
                                  "cooking",
                                  index,
                                );
                              },
                        label: "Cooking",
                        icon: Icons.kitchen,
                        foregroundColor: orderItem.value.status == "cooking" ||
                                orderItem.value.status == "delivering"
                            ? Colors.grey
                            : Colors.purple,
                        backgroundColor: Colors.transparent,
                      ),
                      // assign delivery person
                      SlidableAction(
                        onPressed: orderItem.value.status == "cooking" &&
                                orderItem.value.status != 'delivering'
                            ? (context) {
                                controller.assingDeliveryPerson(
                                    orderItem.value.$id, index);
                              }
                            : null,
                        label: "Assign Delivery Person",
                        icon: Icons.delivery_dining,
                        foregroundColor: orderItem.value.status == "cooking"
                            ? Colors.purple
                            : Colors.grey,
                        backgroundColor: Colors.transparent,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OrderedItemCard(
                        numOfItem: orderItem.value.qty,
                        title: orderItem.value.items.name,
                        description:
                            "${DateFormat("dd/MM/yyyy").format(orderItem.value.orders.createdDate)} | ${orderItem.value.status} | ${orderItem.value.deliveryPerson == null ? "Not Assigned" : orderItem.value.deliveryPerson!.name}",
                        price:
                            orderItem.value.items.price * orderItem.value.qty,
                      ),
                      Text(
                        "Compalints: ${orderItem.value.orders.complaints ?? "No complaints"}",
                      ),
                      Divider(),
                      SizedBox(height: 10,)
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    ).paddingSymmetric(horizontal: defaultPadding);
  }
}
