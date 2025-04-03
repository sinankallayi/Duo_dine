import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restro_admin/app/modules/home/controllers/payment_controller.dart';
import 'refresh_button.dart';

class PaymentsView extends StatelessWidget {
  final PaymentController controller = Get.put(PaymentController());

  PaymentsView({super.key});

  // Helper method to get an icon based on payment status
  IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle;
      case 'pending':
        return Icons.hourglass_empty;
      case 'failed':
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments'),
        actions: [
          RefreshButton(onTap: () => {controller.loadPayments()})
        ],
      ),
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Prominent amount display
                    Text(
                      'Amount: \₹${payment.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Divider(),
                    // Status with dynamic icon
                    Row(
                      children: [
                        Icon(getStatusIcon(payment.status),
                            color: const Color.fromARGB(255, 103, 69, 117)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Status: ${payment.status}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    // Transaction ID with icon
                    Row(
                      children: [
                        const Icon(Icons.receipt,
                            color: Color.fromARGB(255, 93, 87, 87)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Transaction ID: ${payment.transactionId}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    // User with icon
                    Row(
                      children: [
                        const Icon(Icons.person,
                            color: Color.fromARGB(255, 79, 98, 127)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'User: ${payment.userName}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    // Restaurant with icon
                    Row(
                      children: [
                        const Icon(Icons.restaurant,
                            color: Color.fromARGB(255, 81, 47, 47)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Restaurant: ${payment.restaurantName}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
