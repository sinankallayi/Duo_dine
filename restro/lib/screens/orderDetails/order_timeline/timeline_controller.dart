import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:foodly_ui/models/order_items_model.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../models/enums/order_status.dart';
import '../../../models/order_timeline.dart';

class TimelineController extends GetxController {
  OrderItemsModel? item;

  RxList<OrderTimeline> orderTimeline = <OrderTimeline>[].obs;

  @override
  void onInit() {
    item = Get.arguments;
    getOrderTimeline(item!.$id);
    super.onInit();
  }

  Future<void> getOrderTimeline(String $id) async {
    print("Order ID: ${$id}");
    try {
      var data = await db.listDocuments(
        databaseId: dbId,
        collectionId: orderTimelineCollection,
        queries: [
          Query.equal("itemId", item!.$id),
        ],
      );
      var completed = data.documents.map((e) => OrderTimeline.fromJson(e.data)).toList();
      var pending = OrderStatus.values
          .where((i) => ![
                OrderStatus.orderCancelled,
                OrderStatus.orderFailed,
                OrderStatus.refunded,
                OrderStatus.returned,
              ].contains(i))
          .map((e) => OrderTimeline.fromJson(
              {"status": e.value, "itemId": item!.$id, "description": e.statusText}))
          .where((i) => !completed.map((c) => c.status).contains(i.status))
          .toList();
      log("completed ${completed.length}");
      log("Pending ${pending.length}");
      if (!containsAnyStatus(completed,
          [OrderStatus.orderCancelled, OrderStatus.orderFailed, OrderStatus.orderCompleted])) {
        completed.addAll(pending);
      }
      orderTimeline.assignAll(completed);
    } on AppwriteException catch (e) {
      debugPrint(e.message);
    }
  }

  bool containsAnyStatus(List<OrderTimeline> timelines, List<OrderStatus> statusesToCheck) {
    return timelines.any((timeline) => statusesToCheck.contains(timeline.status));
  }
}
