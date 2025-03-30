import 'package:flutter/material.dart';
import 'package:restro_delivery/app/data/models/order_items_model.dart';

class OrderDetailView extends StatelessWidget {
  final OrderItemsModel orderItemsModel;

  const OrderDetailView({super.key, required this.orderItemsModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(orderItemsModel.items.name)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              orderItemsModel.items.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
