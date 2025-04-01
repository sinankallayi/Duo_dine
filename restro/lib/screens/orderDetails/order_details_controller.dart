import 'package:appwrite/appwrite.dart';
import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/data.dart';
import 'package:foodly_ui/functions/payment_controller.dart';
import 'package:foodly_ui/models/cart_model.dart';
import 'package:foodly_ui/models/order_model.dart';
import 'package:get/get.dart';

class OrderDetailsController extends GetxController {
  final PaymentController paymentController = Get.put(PaymentController());
  RxList<CartModel> cartItems = <CartModel>[].obs;
  RxList<OrderModel> orders = <OrderModel>[].obs;
  final cartPrice = 0.0.obs;
  final orderPrice = 0.0.obs;

  @override
  void onInit() {
    if (user == null) return;
    getCartItems();
    getOrders();
    super.onInit();
  }

  Future getCartItems() async {
    cartItems.clear();
    var result = await db.listDocuments(
        databaseId: dbId,
        collectionId: cartCollection,
        queries: [Query.equal('users', user!.$id)]);

    cartItems.value = result.documents
        .map((e) => CartModel.fromJson(e.data))
        .toList()
        .cast<CartModel>();

    cartPrice.value = cartItems.fold(
      0,
      (previousValue, element) =>
          previousValue + element.item.price * element.quantity,
    );
  }

  void getOrders() {
    orders.clear();
    db.listDocuments(
        databaseId: dbId,
        collectionId: ordersCollection,
        queries: [
          Query.equal('users', user!.$id),
          Query.orderDesc('\$createdAt')
        ]).then((result) {
      orders.value = result.documents
          .map((e) => OrderModel.fromJson(e.data))
          .toList()
          .cast<OrderModel>();

      orderPrice.value = orders.fold(
        0,
        (previousValue, element) => previousValue + element.total_price,
      );
    });
  }

  void cancelOrder(int index) {}

  Future<void> removeItemFromCart(String cartItemId) async {
    try {
      // Remove item from Appwrite database
      await db.deleteDocument(
        databaseId: dbId,
        collectionId: cartCollection,
        documentId: cartItemId,
      );

      // Remove from local cart list
      cartItems.removeWhere((item) => item.$id == cartItemId);

      // Update total cart price
      cartPrice.value = cartItems.fold(
        0,
        (previousValue, element) =>
            previousValue + element.item.price * element.quantity,
      );

      Get.snackbar("Success", "Item removed from cart");
    } catch (e) {
      Get.snackbar("Error", "Failed to remove item: $e");
    }
  }
}
