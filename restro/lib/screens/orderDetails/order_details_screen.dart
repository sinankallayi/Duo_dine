import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
      appBar: AppBar(
        title: const Text("Your Orders"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Obx(
            () => Column(
              children: [
                const SizedBox(height: defaultPadding),
                // List of cart items
                ...List.generate(
                  controller.cartItems.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: defaultPadding / 2),
                    child: OrderedItemCard(
                      title: controller.cartItems[index].item.name,
                      description: controller.cartItems[index].item.description,
                      numOfItem: controller.cartItems[index].quantity,
                      price: controller.cartItems[index].item.price *
                          controller.cartItems[index].quantity,
                    ),
                  ),
                ),
                PriceRow(text: "Subtotal", price: controller.cartPrice.value),
                const SizedBox(height: defaultPadding / 2),
                // const PriceRow(text: "Delivery", price: 0),
                // const SizedBox(height: defaultPadding / 2),
                TotalPrice(price: controller.cartPrice.value),
                const SizedBox(height: defaultPadding * 2),
                PrimaryButton(
                  text: "Checkout (\₹${controller.cartPrice.value})",
                  press: () {
                    Get.to(
                      () => const PaymentScreen(),
                      arguments: {
                        "price": controller.cartPrice.value,
                        "items": controller.cartItems
                      },
                    );
                  },
                ),
                const SizedBox(height: defaultPadding),
                Text('Orders', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: defaultPadding),
                ...List.generate(
                  controller.orders.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: defaultPadding / 2),
                    child: Slidable(
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(), // Smooth sliding motion
                        extentRatio:
                            0.3, // How much of the widget the action pane covers
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              // Action to cancel the order
                              // controller.cancelOrder(index);
                            },
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.orange,
                            icon: Icons.cancel,
                            label: 'Cancel Order',
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => const Orders(),
                              arguments: controller.orders[index]);
                        },
                        child: OrderedItemCard(
                          title: DateFormat('dd-MM-yyyy')
                              .format(controller.orders[index].createdDate),
                          description: controller.orders[index].restaurant
                              .map((element) => element.name)
                              .join(', '),
                          numOfItem: 1,
                          price: controller.orders[index].total_price,
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

const List<Map> demoItems = [
  {
    "title": "Cookie Sandwich",
    "price": 7.4,
    "numOfItem": 1,
  },
  {
    "title": "Combo Burger",
    "price": 12,
    "numOfItem": 1,
  },
  {
    "title": "Oyster Dish",
    "price": 8.6,
    "numOfItem": 2,
  },
];
