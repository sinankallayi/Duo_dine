import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';
import 'package:restro_delivery/app/data/enums/order_status.dart';

import '../../../services/notification_service.dart';
import '/app/data/constants.dart';
import '../../../data/enums/delivery_status.dart';
import '../../../data/models/order_items_model.dart';
import '../../../services/db_service.dart';

class HomeController extends GetxController {
  RxList<OrderItemsModel> orderItemsModel = <OrderItemsModel>[].obs;
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  final DbService _dbService = DbService();

  @override
  onReady() {
    getOrders();
    _listenToFavorites();
    super.onReady();
  }

  void _listenToFavorites() {
    _dbService.realtime
        .subscribe(['databases.$dbId.collections.$orderItemsCollection.documents'])
        .stream
        .listen((event) {
          getOrders();
        });
  }

  Future<void> getOrders() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';
      var userId = user?.$id;
      if (userId == null) {
        hasError.value = true;
        errorMessage.value = 'User not logged in';
        log(errorMessage.value);
        isLoading.value = false;
        return;
      }
      log(userId);
      var result = await databases.listDocuments(
        databaseId: dbId,
        collectionId: orderItemsCollection,
        queries: [Query.equal('deliveryPerson', userId), Query.orderDesc('\$createdAt')],
      );
      log(result.documents.length.toString());
      orderItemsModel.value =
          result.documents.map((e) => OrderItemsModel.fromJson(e.data)).toList();
      log("orderItemsModel.first.items.name:  " + orderItemsModel.first.items.name);
    } catch (e) {
      log(e.toString());
      hasError.value = true;
      errorMessage.value = 'Failed to load orders: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changeStatus(OrderItemsModel orderItemsModel, DeliveryStatus status) async {
    print("Changing status to $status");
    var statusText = status.statusText;
    try {
      isLoading.value = true;
      await databases.updateDocument(
        databaseId: dbId,
        collectionId: deliveryPersonsCollection,
        documentId: orderItemsModel.deliveryPerson!.$id,
        data: {'deliveryStatus': status.value},
      );

      if (status == DeliveryStatus.orderPickedUp) {
        statusText = OrderStatus.outForDelivery.statusText;
        await databases.updateDocument(
          databaseId: dbId,
          collectionId: orderItemsCollection,
          documentId: orderItemsModel.$id,
          data: {'status': OrderStatus.outForDelivery.value},
        );
        await databases.createDocument(
          databaseId: dbId,
          collectionId: orderTimelineCollection,
          documentId: ID.unique(),
          data: {
            "itemId": orderItemsModel.$id,
            "status": OrderStatus.outForDelivery.value,
            "description": OrderStatus.outForDelivery.statusText,
          },
        );
      }

      bool isCompleted = DeliveryStatusExtension.isDeliveryCompleted(status);
      bool isFailed = DeliveryStatusExtension.isDeliveryFailed(status);
      if (isCompleted || isFailed) {
        statusText =
            isCompleted
                ? OrderStatus.orderCompleted.statusText
                : OrderStatus.orderFailed.statusText;
        await databases.updateDocument(
          databaseId: dbId,
          collectionId: orderItemsCollection,
          documentId: orderItemsModel.$id,
          data: {
            'deliveryPerson': null,
            'status':
                isCompleted ? OrderStatus.orderCompleted.value : OrderStatus.orderFailed.value,
          },
        );
        await databases.createDocument(
          databaseId: dbId,
          collectionId: orderTimelineCollection,
          documentId: ID.unique(),
          data: {
            "itemId": orderItemsModel.$id,
            "status":
                isCompleted ? OrderStatus.orderCompleted.value : OrderStatus.orderFailed.value,
            "description":
                isCompleted
                    ? OrderStatus.orderCompleted.statusText
                    : OrderStatus.orderFailed.statusText,
          },
        );
      }

      Get.snackbar('Success', 'Ordrer status changed to ${status.statusText}');
      await getOrders();
      if (orderItemsModel.orders.user != null) {
        NotificationService.sendPushNotification(
          statusText,
          'The status of your delivery has been updated to ${statusText}',
          orderItemsModel.orders.user,
        );
      }
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
      await getOrders();
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
      await getOrders();
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
      await getOrders();
    } catch (e) {
      Get.snackbar('Error', 'Failed to accept order: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
