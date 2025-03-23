import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bottom_nav_controller.dart';
import 'restaurants_view.dart';
import 'complaints_view.dart';
import 'payments_view.dart';

class HomeView extends StatelessWidget {
  final BottomNavController navController = Get.put(BottomNavController());

  HomeView({super.key});

  final List<Widget> pages = [
    RestaurantsView(), // Shows the restaurant list
    ComplaintsView(),
    PaymentsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Panel"), centerTitle: true),

      body: Obx(() => pages[navController.selectedIndex.value]),

      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: navController.selectedIndex.value,
          onTap: navController.changeTab,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant),
              label: 'Restaurants',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.report),
              label: 'Complaints',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.payment),
              label: 'Payments',
            ),
          ],
        ),
      ),
    );
  }
}
