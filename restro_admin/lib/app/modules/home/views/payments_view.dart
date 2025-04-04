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
        title: const Text('Payments', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        actions: [
          RefreshButton(onTap: () => controller.loadPayments())
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.hasError.value) {
          return Center(child: Text(controller.errorMessage.value, style: TextStyle(color: Colors.red, fontSize: 16)));
        } else if (controller.payments.isEmpty) {
          return const Center(child: Text('No payments found.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: controller.payments.length,
          itemBuilder: (context, index) {
            final payment = controller.payments[index];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₹${payment.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const Divider(thickness: 1.2),
                    buildInfoRow(Icons.check_circle, 'Status', payment.status, Colors.purple),
                    buildInfoRow(Icons.receipt, 'Transaction ID', payment.transactionId, Colors.grey),
                    buildInfoRow(Icons.person, 'User', payment.userName, Colors.blueAccent),
                    buildInfoRow(Icons.restaurant, 'Restaurant', payment.restaurantName, Colors.brown),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget buildInfoRow(IconData icon, String label, String value, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$label: $value',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
