import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:foodly_ui/functions/payment_controller.dart';
import 'package:get/get.dart';

class PaymentScreen extends GetView<PaymentController> {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PaymentController());
    controller.args = Get.arguments;
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(
              () => CreditCardWidget(
                cardNumber: controller.cardNumber.value,
                expiryDate: controller.expiryDate.value,
                cardHolderName: controller.cardHolderName.value,
                cvvCode: controller.cvvCode.value,
                showBackView: controller.isCvvFocused.value,
                onCreditCardWidgetChange: (CreditCardBrand) {},
              ),
            ),
            CreditCardForm(
              formKey: controller.formKey,
              cardNumber: controller.cardNumber.value,
              expiryDate: controller.expiryDate.value,
              cardHolderName: controller.cardHolderName.value,
              cvvCode: controller.cvvCode.value,
              onCreditCardModelChange: controller.updateCardDetails,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Obx(() => ElevatedButton(
                    onPressed: controller.isProcessing.value
                        ? null
                        : controller.simulatePayment,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      minimumSize:
                          const Size(double.infinity, 50), // Full-width button
                    ),
                    child: controller.isProcessing.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text('Pay ₹${controller.args['price']}'),
                  )),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
