import 'dart:convert';
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/data.dart';
import 'package:foodly_ui/functions/auth.dart';
import 'package:foodly_ui/models/cart_model.dart';
import 'package:foodly_ui/screens/orderDetails/order_details_controller.dart';
import 'package:get/get.dart';

import '../models/enums/order_status.dart';

class PaymentController extends GetxController {
  var args;

  RxBool isProcessing = false.obs;
  RxString cardNumber = ''.obs;
  RxString expiryDate = ''.obs;
  RxString cardHolderName = ''.obs;
  RxString cvvCode = ''.obs;
  RxBool isCvvFocused = false.obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void updateCardDetails(CreditCardModel data) {
    cardNumber.value = data.cardNumber;
    expiryDate.value = data.expiryDate;
    cardHolderName.value = data.cardHolderName;
    cvvCode.value = data.cvvCode;
    isCvvFocused.value = data.isCvvFocused;
  }

  Future<void> simulatePayment() async {
    if (!formKey.currentState!.validate()) {
      Get.snackbar('Error', 'Please enter valid card details', backgroundColor: Colors.red);
      return;
    }

    isProcessing.value = true;

    // Simulate success/failure
    bool isSuccess = true; //DateTime.now().second % 2 == 0;

    if (isSuccess) {
      await _createOrder(args['items'], args['price'], 'success');
    } else {
      await _handleFailedPayment(args['items'], args['price']);
    }

    Get.snackbar(
      isSuccess ? 'Success' : 'Failed',
      isSuccess ? 'Payment Successful, Order Placed!' : 'Payment Failed!',
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      colorText: Colors.white,
    );
  }

  Future<void> _createOrder(List<CartModel> items, double price, String status) async {
    await getUserInfo();
    String orderId = ID.unique();

    await _createDocument(ordersCollection, orderId, {
      'users': user!.$id,
      'itemCount': items.length,
      'total_price': double.parse(price.toStringAsFixed(2)),
      'status': 'pending',
    });

    await Future.wait([
      _deleteCartItems(items),
      _createOrderItems(items, orderId),
      _createPayments(items, price, status),
    ]);

    var userId = user?.$id;
    if (userId != null) {
      await functions.createExecution(
        functionId: funId,
        body: jsonEncode({
          'title': 'New Order Placed',
          'body': '${items.length} ${items.length == 1 ? "item" : "items"} | Amount: ₹$price',
          'users': userId,
        }),
        path: sendMsgPath,
      );
    }

    isProcessing.value = false;

    final orderController = Get.put(OrderDetailsController());
    orderController.getCartItems();
    orderController.getOrders();

    Get.back();
  }

  Future<void> _handleFailedPayment(List<CartModel> items, double price) async {
    _createPayments(items, price, 'failed');
    isProcessing.value = false;
  }

  // Future<void> _createPayments(
  //     List<CartModel> items, double price, String status) async {
  //   for (var item in items) {
  //     await _createDocument(paymentsCollection, ID.unique(), {
  //       'userId': user!.$id,
  //       'userName': user?.name ?? "customer",
  //       'amount': double.parse(item.item.price.toStringAsFixed(2)),
  //       'status': status,
  //       'restaurant': item.item.restaurant.id,
  //     });
  //     log("Created payments: "+item.item.name);
  //   }
  // }

  Future<void> _createPayments(List<CartModel> items, double price, String status) async {
    // Group items by restaurantId and sum the amount
    Map<String, double> restaurantPayments = {};
    Map<String, int> restaurantItemCount = {};
    
    //Grouping Restaurants
    for (var item in items) {
      String restaurantId = item.item.restaurant.id;
      double amount = item.item.price;

      if (restaurantPayments.containsKey(restaurantId)) {
        restaurantPayments[restaurantId] = (restaurantPayments[restaurantId] ?? 0) + amount;
        restaurantItemCount[restaurantId] = (restaurantItemCount[restaurantId] ?? 0) + 1;
      } else {
        restaurantPayments[restaurantId] = amount;
        restaurantItemCount[restaurantId] = 1;
      }
    }

    // Create a payment entry for each restaurant
    var transactionId = ID.unique();
    for (var entry in restaurantPayments.entries) {
      var restaurantId = entry.key;
      var amount = entry.value;
      var itemCount = restaurantItemCount[entry.key];
      await _createDocument(paymentsCollection, ID.unique(), {
        'userId': user!.$id,
        'userName': user?.name ?? "customer",
        'amount': double.parse(entry.value.toStringAsFixed(2)), // Final summed amount
        'status': status,
        'restaurant': entry.key,
        'transactionId': transactionId,
      });
      log("Created payment for restaurant: ${entry.key}, Amount: ${entry.value}");

       var restaurantOwnerId = restaurantId;
      await functions.createExecution(
        functionId: funId,
        body: jsonEncode({
          'title': 'New Order Placed',
          'body': '${itemCount} ${itemCount == 1 ? "item" : "items"} | Amount: ₹$amount',
          'users': restaurantOwnerId,
        }),
        path: sendMsgPath,
      );
    }
  }

  Future<void> _deleteCartItems(List<CartModel> items) async {
    for (var item in items) {
      await _deleteDocument(cartCollection, item.$id);
    }
  }

  Future<void> _createOrderItems(List<CartModel> items, String orderId) async {
    for (var item in items) {
      var itemId = ID.unique();
      await _createDocument(orderItemsCollection, itemId, {
        'orders': orderId,
        'items': item.item.$id,
        'qty': item.quantity,
        'restaurant': item.item.restaurant.id,
      });

      await _createDocument(
        orderTimelineCollection,
        ID.unique(),
        {
          "itemId": itemId,
          "status": OrderStatus.orderPlaced.value,
          "description": OrderStatus.orderPlaced.statusText,
        },
      );

      log("Created orderItem: " + item.item.name);
    }
  }

  Future<void> _createDocument(String collection, String docId, Map<String, dynamic> data) async {
    try {
      await db.createDocument(
          databaseId: dbId, collectionId: collection, documentId: docId, data: data);
    } on AppwriteException catch (e) {
      log('Error creating document: ${e.code} - ${e.message}');
    }
  }

  Future<void> _deleteDocument(String collection, String docId) async {
    try {
      await db.deleteDocument(databaseId: dbId, collectionId: collection, documentId: docId);
    } on AppwriteException catch (e) {
      log('Error deleting document: ${e.code} - ${e.message}');
    }
  }
}
