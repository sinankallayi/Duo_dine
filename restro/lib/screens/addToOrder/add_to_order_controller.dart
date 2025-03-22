import 'package:appwrite/appwrite.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/data.dart';
import 'package:foodly_ui/models/menu_items_model.dart';
import 'package:foodly_ui/screens/orderDetails/order_details_controller.dart';
import 'package:foodly_ui/screens/orderDetails/order_details_screen.dart';
import 'package:get/get.dart';

class AddToOrderController extends GetxController {
  MenuItemModel? item;
  final numOfItems = 1.obs;
  final isLoading = false.obs;

  // Handle API errors consistently
  void _handleError(String message) {
    isLoading.value = false;
    Fluttertoast.showToast(msg: message);
  }

  // Verify or create user document
  Future<bool> _verifyUserDocument() async {
    try {
      await db.getDocument(
        databaseId: dbId,
        collectionId: userCollection,
        documentId: user!.$id,
      );
      return true;
    } on AppwriteException catch (e) {
      if (e.code == 404) {
        await db.createDocument(
          databaseId: dbId,
          collectionId: userCollection,
          documentId: user!.$id,
          data: {"role": "customer"},
        );
        return true;
      }
      print(e.message);
      _handleError(e.message!);
      return false;
    }
  }

  Future<void> addOrder() async {
    if (item == null) {
      _handleError("No item selected");
      return;
    }

    if (numOfItems.value < 1) {
      _handleError("Invalid quantity");
      return;
    }

    isLoading.value = true;

    try {
      // Verify user document exists
      if (!await _verifyUserDocument()) return;

      print("Adding order to cart");

      var map = {
        "quantity": numOfItems.value,
        "users": user!.$id,
        "items": item!.$id
      };

      print(map);

      // Add order to cart
      await db.createDocument(
        databaseId: dbId,
        collectionId: cartCollection,
        documentId: ID.unique(),
        data: map,
      );

      isLoading.value = false;
      Fluttertoast.showToast(msg: "Order added to cart");
      Get.put(OrderDetailsController()).getCartItems();
      Get.to(() => const OrderDetailsScreen());
    } on AppwriteException catch (e) {
      print(e.message);
      _handleError(e.message!);
    }
  }
}
