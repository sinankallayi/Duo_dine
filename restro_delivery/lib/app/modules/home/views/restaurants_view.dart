import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'restaurant_detail_view.dart';

class RestaurantsView extends GetView<HomeController> {
  const RestaurantsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (controller.restaurants.isEmpty) {
        return const Center(child: Text('No restaurants available'));
      } else {
        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: controller.restaurants.length,
          itemBuilder: (context, index) {
            final restaurant = controller.restaurants[index];

            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  // Restaurant Details (Clickable)
                  ListTile(
                    title: Text(restaurant.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('📍 ${restaurant.location}'),
                    trailing: restaurant.approved
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : const Icon(Icons.cancel, color: Colors.red),
                    onTap: () {
                      Get.to(
                          () => RestaurantDetailView(restaurant: restaurant));
                    },
                  ),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Approve Button
                      TextButton(
                        onPressed: () {
                          controller.approve(restaurant.id);
                        },
                        child: const Text('Approve',
                            style: TextStyle(color: Colors.green)),
                      ),

                      // Reject Button
                      TextButton(
                        onPressed: () {
                          controller.reject(restaurant.id);
                        },
                        child: const Text('Reject',
                            style: TextStyle(color: Colors.red)),
                      ),

                      // Delete Button
                      TextButton(
                        onPressed: () {
                          controller.delete(restaurant.id);
                        },
                        child: const Text('Delete',
                            style: TextStyle(color: Colors.grey)),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }
    });
  }
}
