import 'package:flutter/material.dart';
import 'package:foodly_ui/screens/orderDetails/order_details_controller.dart';
import 'package:foodly_ui/screens/orderDetails/orders.dart';
import 'package:foodly_ui/screens/orderDetails/payment_screen.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../components/buttons/primary_button.dart';
import '../../constants.dart';
import 'components/order_item_card.dart';
import 'components/price_row.dart';
import 'components/total_price.dart';

class OrderDetailsScreen extends GetView<OrderDetailsController> {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OrderDetailsController());
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light gray background
      appBar: AppBar(
        title: const Text("Your Orders"),
        //backgroundColor: Colors.blue, // Standard blue for the app bar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: defaultPadding),
                if (controller.cartItems.isNotEmpty)
                  Column(children: [
                    Text('Cart', style: Theme.of(context).textTheme.titleMedium),
                    // **Cart Items**
                    ...List.generate(
                      controller.cartItems.length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
                        child: Card(
                          color: Colors.white, // White card for cart items
                          elevation: 2, // Subtle shadow
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // Rounded corners
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(defaultPadding / 2),
                            child: Row(
                              children: [
                                Expanded(
                                  child: OrderedItemCard(
                                    title: controller.cartItems[index].item.name,
                                    description: controller.cartItems[index].item.description,
                                    numOfItem: controller.cartItems[index].quantity,
                                    price: controller.cartItems[index].item.price *
                                        controller.cartItems[index].quantity,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Color(0xFFEF5350)), // Muted red delete icon
                                  onPressed: () => controller
                                      .removeItemFromCart(controller.cartItems[index].$id),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: defaultPadding),

                    // **Price Section**
                    Card(
                      color: Colors.white, // White card for price
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Color(0xFF64B5F6)), // Light blue border
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: Column(
                          children: [
                            PriceRow(text: "Subtotal", price: controller.cartPrice.value),
                            const SizedBox(height: defaultPadding / 2),
                            TotalPrice(price: controller.cartPrice.value),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: defaultPadding * 2),

                    // **Checkout Button**
                    PrimaryButton(
                      text: "Checkout (\₹${controller.cartPrice.value})",
                      press: () {
                        Get.to(
                          () => const PaymentScreen(),
                          arguments: {
                            "price": controller.cartPrice.value,
                            "items": controller.cartItems,
                          },
                        );
                      },
                    ),
                    const SizedBox(height: defaultPadding * 2),
                  ]),

                // **Orders Section**
                Text('Orders', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: defaultPadding),
                ...List.generate(
                  controller.orders.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => const Orders(), arguments: controller.orders[index]);
                      },
                      child: Card(
                        color: Color(0xFFE3F2FD),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(defaultPadding / 2),
                          child: OrderedItemCard(
                            title: '${controller.orders[index].itemCount} ${controller.orders[index].itemCount == 1 ? 'item' : 'items'}',
                            description: DateFormat('d MMM yyyy hh:mm a')
                                .format(controller.orders[index].createdDate),
                            numOfItem: 0,
                            price: controller.orders[index].total_price,
                            status: controller.orders[index].status,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
