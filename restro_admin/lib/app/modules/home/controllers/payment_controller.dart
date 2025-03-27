import 'package:get/get.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:restro_admin/app/data/models/payment_model.dart';
import 'package:restro_admin/app/data/constants.dart';

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

      var result = await databases.listDocuments(
          databaseId: dbId, collectionId: paymentCollection);

      payments.value =
          result.documents.map((e) => Payment.fromJson(e.data)).toList();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load payments: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deletePayment(String id) async {
    try {
      isLoading.value = true;
      await databases.deleteDocument(
          databaseId: dbId, collectionId: paymentCollection, documentId: id);
      Get.snackbar('Success', 'Payment deleted successfully');
      await loadPayments();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete payment: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
