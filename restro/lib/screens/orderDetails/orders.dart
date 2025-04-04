import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/models/enums/order_status.dart';
import 'package:foodly_ui/models/order_items_model.dart';
import 'package:foodly_ui/models/order_model.dart';
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
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Order Details',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Center(
              child: Text(
                DateFormat('dd/MM/yyyy').format(controller.item!.createdDate),
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order ID Section
              Text(
                "Order ID: ${controller.item!.$id}",
                style:
                    Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              if (controller.item!.address != null)
                Text(
                  "Address: ${controller.item!.address}",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              const SizedBox(height: defaultPadding),
              // List of Order Items
              ...List.generate(
                controller.items.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Get.to(
                        () => const TimelineScreen(),
                        arguments: controller.items[index],
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 2,
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.items[index].items.name,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${controller.items[index].status.statusText}",
                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                            ),
                            if (controller.items[index].status == OrderStatus.orderCancelled)
                              Text(
                                "Your order has been canceled. The refund will be processed to the same account within 7 working days.",
                                style: TextStyle(fontSize: 14, color: Colors.red[400]),
                              ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Quantity: ${controller.items[index].qty}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  "₹${controller.items[index].items.price * controller.items[index].qty}",
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              // Total Price
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Total: ₹${controller.items.fold(0.0, (previousValue, element) => previousValue + element.items.price * element.qty)}",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: defaultPadding),
              // Complaints Section
              controller.item!.complaints == null
                  ? TextField(
                      controller: controller.complaintsController,
                      maxLength: 1000,
                      maxLines: 5,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: IconButton(
                          onPressed: controller.isSenting.value
                              ? null
                              : () {
                                  controller.sendComplaints();
                                },
                          icon: controller.isSenting.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.send),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: primaryColor),
                        ),
                        labelText: 'Complaints',
                        hintText: 'Enter your complaints here',
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(defaultPadding),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Text(
                        'Complaints: ${controller.item!.complaints}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
            ],
          ),
        ),
      ),
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

      items.assignAll(data.documents.map((e) => OrderItemsModel.fromJson(e.data)).toList());
    } on AppwriteException catch (e) {
      debugPrint(e.message);
      debugPrint(e.response);
    }
  }

  Future<void> sendComplaints() async {
    if (complaintsController.text.isNotEmpty) {
      isSenting.value = true;
      try {
        await db.updateDocument(
          databaseId: dbId,
          collectionId: ordersCollection,
          documentId: item!.$id,
          data: {
            'complaints': complaintsController.text,
          },
        );
        complaintsController.clear();
        Get.snackbar('Success', 'Complaint sent successfully', snackPosition: SnackPosition.BOTTOM);
      } on AppwriteException catch (e) {
        debugPrint(e.message);
        debugPrint(e.response);
        Get.snackbar('Error', 'Failed to send complaint', snackPosition: SnackPosition.BOTTOM);
      } finally {
        isSenting.value = false;
      }
    } else {
      Get.snackbar('Error', 'Complaint cannot be empty', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
