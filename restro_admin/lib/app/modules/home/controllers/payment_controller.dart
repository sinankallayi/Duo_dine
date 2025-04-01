import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';
import 'package:restro_admin/app/data/constants.dart';
import 'package:restro_admin/app/data/models/payment_model.dart';

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
        databaseId: dbId,
        collectionId: paymentCollection,
        queries: [
          Query.orderDesc('\$createdAt'),
        ],
      );

      payments.value =
          result.documents.map((e) => Payment.fromJson(e.data)).toList();

      // List<Payment> paymentList = [];
      // for (var doc in result.documents) {
      //   var payment = Payment.fromJson(doc.data);

      // // Fetch user details only if userId exists
      // if (payment.userId.isNotEmpty) {
      //   try {
      //     var userDoc = await databases.getDocument(
      //       databaseId: dbId,
      //       collectionId:
      //           userCollection, // Replace with your User Collection ID
      //       documentId: payment.userId,
      //     );
      //     payment.userName =
      //         userDoc.data['userName'] ?? 'Unknown User'; // Store user name
      //   } catch (e) {
      //     payment.userName = 'Unknown User'; // Default if user fetch fails
      //   }
      // }

      //   paymentList.add(payment);
      // }

      // payments.value = paymentList;
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
  //     await databases.deleteDocument(
  //         databaseId: dbId, collectionId: paymentCollection, documentId: id);
  //     Get.snackbar('Success', 'Payment deleted successfully');
  //     await loadPayments();
  //   } catch (e) {
  //     Get.snackbar('Error', 'Failed to delete payment: ${e.toString()}');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
}
