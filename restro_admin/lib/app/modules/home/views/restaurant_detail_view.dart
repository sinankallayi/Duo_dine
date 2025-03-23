import 'package:flutter/material.dart';
import 'package:restro_admin/app/data/models/restaurant_model.dart'; // ✅ Fix import path

class RestaurantDetailView extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantDetailView({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              restaurant.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),
            Text('📌 Address: ${restaurant.address}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 25),
            Text('📍 Location: ${restaurant.location}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 25),
            Text('📞 Phone: ${restaurant.phone}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 25),
            Text(
              restaurant.approved ? '✅ Approved' : '❌ Not Approved',
              style: TextStyle(
                fontSize: 18,
                color: restaurant.approved ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
