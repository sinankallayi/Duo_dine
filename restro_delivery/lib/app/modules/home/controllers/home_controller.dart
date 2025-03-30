import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';

import '/app/data/constants.dart';
import '../../../data/enums/delivery_status.dart';
import '../../../data/models/order_items_model.dart';

class HomeController extends GetxController {
  RxList<OrderItemsModel> orderItemsModel = <OrderItemsModel>[].obs;
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  @override
  onReady() {
    loadOrders();
    super.onReady();
  }

  Future<void> loadOrders() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';
      var userId = user?.$id;
      if (userId == null) {
        hasError.value = true;
        errorMessage.value = 'User not logged in';
        isLoading.value = false;
        return;
      }

      var result = await databases.listDocuments(
        databaseId: dbId,
        collectionId: orderItemsCollection,
        queries: [Query.equal('deliveryPerson', userId)],
      );
      orderItemsModel.value =
          result.documents.map((e) => OrderItemsModel.fromJson(e.data)).toList();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load orders: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changeStatus(OrderItemsModel orderItemsModel, DeliveryStatus status) async {
    print("Changing status to $status");
    try {
      isLoading.value = true;
      await databases.updateDocument(
        databaseId: dbId,
        collectionId: deliveryPersonsCollection,
        documentId: orderItemsModel.deliveryPerson!.$id,
        data: {'deliveryStatus': status.value},
      );
      Get.snackbar('Success', 'Ordrer status changed to ${status.statusText}');
      await loadOrders();
    } catch (e) {
      Get.snackbar('Error', 'Failed to accept order: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> accept(OrderItemsModel orderItemsModel) async {
    try {
      isLoading.value = true;
      await databases.updateDocument(
        databaseId: dbId,
        collectionId: deliveryPersonsCollection,
        documentId: orderItemsModel.deliveryPerson!.$id,
        data: {'deliveryStatus': DeliveryStatus.acceptedOrder.value},
      );
      Get.snackbar('Success', 'Delivery person accepted the order');
      await loadOrders();
    } catch (e) {
      Get.snackbar('Error', 'Failed to accept order: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> reject(OrderItemsModel orderItemsModel) async {
    try {
      isLoading.value = true;
      await databases.updateDocument(
        databaseId: dbId,
        collectionId: deliveryPersonsCollection,
        documentId: orderItemsModel.deliveryPerson!.$id,
        data: {'deliveryStatus': DeliveryStatus.rejectedOrder.value},
      );

      await databases.updateDocument(
        databaseId: dbId,
        collectionId: orderItemsCollection,
        documentId: orderItemsModel.$id,
        data: {'deliveryPerson': null, 'status': 'cooking'},
      );
      Get.snackbar('Success', 'Delivery person rejected the order');
      await loadOrders();
    } catch (e) {
      Get.snackbar('Error', 'Failed to reject order: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> headToRestaurant(OrderItemsModel orderItemsModel) async {
    try {
      isLoading.value = true;
      await databases.updateDocument(
        databaseId: dbId,
        collectionId: deliveryPersonsCollection,
        documentId: orderItemsModel.deliveryPerson!.$id,
        data: {'deliveryStatus': DeliveryStatus.headingToRestaurant.value},
      );
      Get.snackbar('Success', 'Delivery person headed to restaurant');
      await loadOrders();
    } catch (e) {
      Get.snackbar('Error', 'Failed to accept order: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
