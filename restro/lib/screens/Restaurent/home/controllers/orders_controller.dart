import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/data.dart';
import 'package:foodly_ui/models/delivery_person_model.dart';
import 'package:foodly_ui/models/order_items_model.dart';
import 'package:foodly_ui/screens/Restaurent/home/widgets/delivery_persons_list.dart';
import 'package:get/get.dart';
import 'dart:convert';

import '../../../../models/enums/delivery_status.dart';
import '../../../../models/enums/order_status.dart';
import '../../../../services/db_service.dart';
import '../../../../services/notification_service.dart';

class OrdersController extends GetxController {
  RxBool isLoading = true.obs;
  RxBool deliveyIsLoading = true.obs;
  RxList<OrderItemsModel> orderItems = <OrderItemsModel>[].obs;
  RxList<DeliveryPersonModel> deliveryPersons = <DeliveryPersonModel>[].obs;
  RxList<DeliveryPersonModel> filteredDeliveryPersons = <DeliveryPersonModel>[].obs;
  final DbService _dbService = DbService();

  @override
  onReady() {
    getOrders();
    _listenToFavorites();
    super.onReady();
  }

  void _listenToFavorites() {
    _dbService.realtime
        .subscribe(['databases.$dbId.collections.order_items.documents'])
        .stream
        .listen((event) {
          getOrders();
        });
  }

  void getOrders() async {
    // print(restaurant.value!.id);
    isLoading.value = true;

    orderItems.clear();

    var result = await db.listDocuments(
      databaseId: dbId,
      collectionId: orderItemsCollection,
      queries: [
        Query.equal('restaurant', restaurant.value!.id),
        Query.notEqual('status', OrderStatus.returned.value),
        Query.notEqual('status', OrderStatus.refunded.value),
        Query.notEqual('status', OrderStatus.orderFailed.value),
        Query.notEqual('status', OrderStatus.orderCompleted.value),
        Query.orderDesc('\$createdAt'),
      ],
    );

    orderItems = result.documents.map((e) => OrderItemsModel.fromJson(e.data)).toList().obs;

    isLoading.value = false;
  }

  Future<void> updateOrderStatus(OrderItemsModel orderItem, OrderStatus nextStatus) async {
    try {
      await db.updateDocument(
        databaseId: dbId,
        collectionId: orderItemsCollection,
        documentId: orderItem.$id,
        data: {
          "status": nextStatus.value,
          "orders": orderItem.orders.$id,
        },
      );

      await db.createDocument(
        databaseId: dbId,
        collectionId: orderTimelineCollection,
        documentId: ID.unique(),
        data: {
          "itemId": orderItem.$id,
          "status": nextStatus.value,
          "description": nextStatus.statusText,
        },
      );
      getOrders();
      NotificationService.sendPushNotification('Order Status Updated',
          'The status of your order has been updated to $nextStatus', getId(orderItem.orders.user));
    } on AppwriteException catch (e) {
      print(e.message);
    }
  }

  Future<void> updateDeliveryPersonStatus(
      OrderItemsModel orderItem, DeliveryStatus nextStatus) async {
    print("updating order status to ${nextStatus.value}");
    try {
      await db.updateDocument(
        databaseId: dbId,
        collectionId: deliveryPersonsCollection,
        documentId: orderItem.deliveryPerson!.$id,
        data: {'deliveryStatus': nextStatus.value},
      );

      NotificationService.sendPushNotification(
          nextStatus.statusText,
          'The status of your delivery has been updated to ${nextStatus.statusText}',
          getId(orderItem.orders.user));
    } on AppwriteException catch (e) {
      print(e.message);
    }

    getOrders();
  }

  // Future<void> updateOrderStatusOld(id, String s, int index) async {
  //   print("updating order status to $s");
  //   isLoading.value = true;
  //   try {
  //     await db.updateDocument(
  //       databaseId: dbId,
  //       collectionId: orderItemsCollection,
  //       documentId: id,
  //       data: {
  //         "status": s,
  //       },
  //     );

  //     await functions.createExecution(
  //       functionId: funId,
  //       body: jsonEncode({
  //         'title': 'Order Status Updated',
  //         'body': 'The status of your order has been updated to $s',
  //         'users': getId(orderItems[index].orders.user),
  //       }),
  //       path: sendMsgPath,
  //     );
  //   } on AppwriteException catch (e) {
  //     print(e.message);
  //   }
  //   isLoading.value = false;
  //   getOrders();
  // }

  Future<void> assignDeliveryPerson(
      OrderItemsModel orderItemsModel, DeliveryPersonModel deliveryPerson) async {
    await _dbService.clearDeliveryPersonFromOrders(deliveryPerson.$id);
    await db.updateDocument(
      databaseId: dbId,
      collectionId: orderItemsCollection,
      documentId: orderItemsModel.$id,
      data: {
        "deliveryPerson": deliveryPerson.$id,
        "orders": orderItemsModel.orders.$id,
      },
    );

    await db.updateDocument(
      databaseId: dbId,
      collectionId: deliveryPersonsCollection,
      documentId: deliveryPerson.$id,
      data: {'deliveryStatus': DeliveryStatus.newOrderAssigned.value},
    );

    getOrders();
    Get.back();
  }

  Future<void> showDeliveryPersons(OrderItemsModel orderItemsModel) async {
    // assign delivery person
    // show bottom sheet with delivery person list

    Get.showOverlay(
      asyncFunction: () async {
        deliveyIsLoading.value = true;

        await getDeliveryPersons();
      },
      loadingWidget: const Center(
        child: CircularProgressIndicator(),
      ),
    );

    Get.bottomSheet(
      DeliveryPersonsList(
        orderItemsModel: orderItemsModel,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
    );
  }

  getDeliveryPersons() async {
    var result =
        await db.listDocuments(databaseId: dbId, collectionId: deliveryPersonsCollection, queries: [
      ...DeliveryStatusExtension.inProgressStates
          .map((e) => Query.notEqual('deliveryStatus', e.value)),
    ]);

    deliveryPersons =
        result.documents.map((e) => DeliveryPersonModel.fromJson(e.data)).toList().obs;
    filteredDeliveryPersons.value = deliveryPersons;
    deliveyIsLoading.value = false;
  }

  void searchDeliveryPersons(String value) {
    deliveyIsLoading.value = true;

    final query = value.toLowerCase();
    filteredDeliveryPersons.value =
        deliveryPersons.where((element) => element.name.toLowerCase().contains(query)).toList();

    deliveyIsLoading.value = false;
  }

  getId(jsonString) {
    // e.g., "{address: null, location: null, $id: 678e5a5cc4bf1c205afb, ...}"
    RegExp regExp = RegExp(r'\$id:\s*([a-zA-Z0-9]+)');
    Match? match = regExp.firstMatch(jsonString!);
    String? id = match?.group(1);

    return id;
  }
}
