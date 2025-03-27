import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restro_admin/app/modules/home/controllers/payment_controller.dart';

class PaymentsView extends StatelessWidget {
  final PaymentController controller = Get.put(PaymentController());

  PaymentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payments')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.hasError.value) {
          return Center(child: Text(controller.errorMessage.value));
        } else if (controller.payments.isEmpty) {
          return const Center(child: Text('No payments found.'));
        }

        return ListView.builder(
          itemCount: controller.payments.length,
          itemBuilder: (context, index) {
            final payment = controller.payments[index];
            return Card(
              child: ListTile(
                title: Text('Amount: \₹${payment.amount.toStringAsFixed(2)}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Status: ${payment.status}'),
                    Text('User ID: ${payment.userId}'),
                    Text('Restaurant ID: ${payment.restaurantId}'),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    controller.deletePayment(payment.id);
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
