import 'package:flutter/material.dart';
import 'package:foodly_ui/models/order_items_model.dart';
import 'package:foodly_ui/screens/Restaurent/home/controllers/orders_controller.dart';
import 'package:get/get.dart';

class DeliveryPersonsList extends GetView<OrdersController> {
  final OrderItemsModel orderItemsModel;
  const DeliveryPersonsList({super.key, required this.orderItemsModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Delivery Persons"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Delivery Persons',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) {
                controller.searchDeliveryPersons(value);
              },
            ),
          ),
        ),
      ),
      body: Obx(
        () {
          if (controller.deliveyIsLoading.value) {
            return const SizedBox.expand();
          } else {
            if (controller.filteredDeliveryPersons.isEmpty) {
              return const Center(
                child: Text("No available drivers at the moment"),
              );
            }
            if (controller.assigningIsLoading.value) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text("Assigning..."),
                  ],
                ),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              itemCount: controller.filteredDeliveryPersons.length,
              itemBuilder: (context, index) {
                return Obx(
                  () => ListTile(
                    title: Text(
                      controller.filteredDeliveryPersons[index].name,
                      maxLines: 1,
                    ),
                    subtitle: Text(
                      "${controller.filteredDeliveryPersons[index].phone}\n${controller.filteredDeliveryPersons[index].location}",
                    ),
                    onTap: () {
                      controller.assignDeliveryPerson(
                        orderItemsModel,
                        controller.filteredDeliveryPersons[index],
                      );
                    },
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            );
          }
        },
      ),
    );
  }
}
