import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/models/order_items_model.dart';
import 'package:foodly_ui/models/order_model.dart';
import 'package:foodly_ui/screens/orderDetails/components/order_item_card.dart';
import 'package:foodly_ui/screens/orderDetails/order_timeline/timeline_screen.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Orders extends GetView<OrdersController> {
  const Orders({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(OrdersController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        actions: [
          // date
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Text(
              DateFormat('dd/MM/yyyy').format(controller.item!.createdDate),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPadding),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // order id
                Text("Order ID: ${controller.item!.$id}"),
                const SizedBox(height: defaultPadding),
                ...List.generate(
                  controller.items.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: defaultPadding / 2),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Get.to(
                          () => const TimelineScreen(),
                          arguments: controller.items[index],
                        );
                      },
                      child: OrderedItemCard(
                        title: controller.items[index].items.name,
                        description:
                            "${controller.items[index].status} - click to view timeline",
                        numOfItem: controller.items[index].qty,
                        price: controller.items[index].items.price *
                            controller.items[index].qty,
                      ),
                    ),
                  ),
                ),
                // total price
                const SizedBox(height: defaultPadding),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Total: ₹${controller.items.fold(0.0, (previousValue, element) => previousValue + element.items.price * element.qty)}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                // text field for complaints
                const SizedBox(height: defaultPadding),
                controller.item!.complaints == null
                    ? TextField(
                        controller: controller.complaintsController,
                        maxLength: 1000,
                        maxLines: 5,
                        decoration: InputDecoration(
                          // send complaints
                          suffixIcon: IconButton(
                            onPressed: controller.isSenting.value
                                ? null
                                : () {
                                    controller.sendComplaints();
                                  },
                            icon: controller.isSenting.value
                                ? const CircularProgressIndicator()
                                : const Icon(Icons.send),
                          ),
                          border: const OutlineInputBorder(),
                          labelText: 'Complaints',
                          hintText: 'Enter your complaints here',
                        ),
                      )
                    : Text('Complaints: ${controller.item!.complaints}'),
              ],
            ),
          )),
    );
  }
}

class OrdersController extends GetxController {
  RxBool isSenting = false.obs;
  OrderModel? item;
  RxList<OrderItemsModel> items = <OrderItemsModel>[].obs;
  TextEditingController complaintsController = TextEditingController();

  @override
  void onInit() {
    item = Get.arguments;
    getItems(item!.$id);
    super.onInit();
  }

  Future<void> getItems(String $id) async {
    print("Order ID: ${$id}");
    try {
      var data = await db.listDocuments(
        databaseId: dbId,
        collectionId: orderItemsCollection,
        queries: [
          Query.equal("orders", item!.$id),
        ],
      );
      for (var element in data.documents) {
        items.add(OrderItemsModel.fromJson(element.data));
      }
    } on AppwriteException catch (e) {
      debugPrint(e.message);
      debugPrint(e.response);
    }
  }

  Future<void> sendComplaints() async {
    if (complaintsController.text.isNotEmpty) {
      isSenting.value = true;
      try {
        // send complaints
        await db.updateDocument(
          databaseId: dbId,
          collectionId: ordersCollection,
          documentId: item!.$id,
          data: {
            'complaints': complaintsController.text,
          },
        );
        complaintsController.clear();
        Get.snackbar('Success', 'Complaint sent successfully',
            snackPosition: SnackPosition.BOTTOM);
      } on AppwriteException catch (e) {
        debugPrint(e.message);
        debugPrint(e.response);
        Get.snackbar('Error', 'Failed to send complaint',
            snackPosition: SnackPosition.BOTTOM);
      } finally {
        isSenting.value = false;
      }
    } else {
      Get.snackbar('Error', 'Complaint cannot be empty',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
