import 'package:flutter/material.dart';
import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/screens/Restaurent/home/controllers/orders_controller.dart';
import 'package:get/get.dart';

class DeliveryPersonsList extends GetView<OrdersController> {
  final String $id;
  final int index;
  const DeliveryPersonsList(
      {super.key, required this.$id, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Delivery Persons"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
      body: Container(
        color: Colors.white,
        child: Obx(
          () {
            if (controller.deliveyIsLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.separated(
                itemCount: controller.deliveryPersons.length,
                itemBuilder: (context, index) {
                  return Obx(
                    () => ListTile(
                      title: Text(
                        controller.deliveryPersons[index].name,
                        maxLines: 1,
                      ),
                      subtitle: Text(
                        "${controller.deliveryPersons[index].phone}\n${controller.deliveryPersons[index].location}",
                      ),
                      onTap: () {
                        // assign delivery person
                        db.updateDocument(
                          databaseId: dbId,
                          collectionId: orderItemsCollection,
                          documentId: $id,
                          data: {
                            "deliveryPerson":
                                controller.deliveryPersons[index].$id,
                          },
                        );

                        controller.updateOrderStatus($id, 'delivering', index);

                        controller.getOrders();
                        Get.back();
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
      ),
    );
  }
}
