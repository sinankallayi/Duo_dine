import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/constants.dart';
import '../../account/account_view.dart';
import '../controllers/bottom_nav_controller.dart';
import 'orders_view.dart';

class HomeView extends StatelessWidget {
  final BottomNavController navController = Get.put(BottomNavController());

  HomeView({super.key});

  final List<Widget> pages = [OrdersView(), AccountsView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delivery Dashboard"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                if (user != null) const Icon(CupertinoIcons.person, color: Colors.black),
                Text(user?.name ?? "Guest", style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),

      body: Obx(() => pages[navController.selectedIndex.value]),

      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: navController.selectedIndex.value,
          onTap: navController.changeTab,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Orders'),
            BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
