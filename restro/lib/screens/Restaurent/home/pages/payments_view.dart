import 'package:flutter/material.dart';
import 'package:foodly_ui/screens/Restaurent/home/controllers/payment_controller.dart';
import 'package:get/get.dart';

class PaymentsView extends StatelessWidget {
  final PaymentController controller = Get.put(PaymentController());

  PaymentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments'),
        centerTitle: true,
        //backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.black,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.hasError.value) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: const TextStyle(
                  color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          );
        } else if (controller.payments.isEmpty) {
          return const Center(
            child: Text(
              'No payments found.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView.builder(
            itemCount: controller.payments.length,
            itemBuilder: (context, index) {
              final payment = controller.payments[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: Icon(
                    payment.status == 'success'
                        ? Icons.check_circle
                        : Icons.error,
                    color:
                        payment.status == 'success' ? Colors.green : Colors.red,
                  ),
                  title: Text(
                    '₹${payment.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        'Transaction ID: ${payment.transactionId}',
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black87),
                      ),
                      Text(
                        'Status: ${payment.status}',
                        style: TextStyle(
                          fontSize: 14,
                          color: payment.status == 'success'
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'User: ${payment.userName}',
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
