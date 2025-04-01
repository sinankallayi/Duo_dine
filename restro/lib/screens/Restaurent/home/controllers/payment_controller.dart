import 'package:appwrite/appwrite.dart';
import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/data.dart';
import 'package:foodly_ui/models/payment_model.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController {
  RxList<Payment> payments = <Payment>[].obs;
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  @override
  Future<void> onReady() async {
    await loadPayments();
  }

  Future<void> loadPayments() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      var result = await db.listDocuments(
          databaseId: dbId,
          collectionId: paymentsCollection,
          queries: [
            Query.equal('restaurant', restaurant.value!.id),
            Query.orderDesc('\$createdAt')
          ]);

      payments.value =
          result.documents.map((e) => Payment.fromJson(e.data)).toList();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load payments: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> deletePayment(String id) async {
  //   try {
  //     isLoading.value = true;
  //     await db.deleteDocument(
  //         databaseId: dbId, collectionId: paymentsCollection, documentId: id);
  //     Get.snackbar('Success', 'Payment deleted successfully');
  //     await loadPayments();
  //   } catch (e) {
  //     Get.snackbar('Error', 'Failed to delete payment: ${e.toString()}');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
}
