import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/data.dart';
import 'package:foodly_ui/screens/Restaurent/home/controllers/items_controller.dart';
import 'package:foodly_ui/screens/Restaurent/home/controllers/orders_controller.dart';
import 'package:foodly_ui/screens/Restaurent/home/pages/items_screen.dart';
import 'package:foodly_ui/screens/Restaurent/home/pages/orders_screen.dart';
import 'package:foodly_ui/screens/Restaurent/home/pages/settings_screen.dart';
import 'package:get/get.dart';

class RestHomeScreen extends StatefulWidget {
  const RestHomeScreen({super.key});

  @override
  _RestHomeScreenState createState() => _RestHomeScreenState();
}

class _RestHomeScreenState extends State<RestHomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const ItemsScreen(),
    const OrdersScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    Get.put(ItemsScreenController());
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        Get.put(OrdersController()).getOrders();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            restaurant.value?.name ?? "Restaurant Name",
          ),
        ),
        actions: [
          if (_selectedIndex == 1)
            TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: primaryColor,
                ),
                label: const Text('Refresh'),
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  Get.put(OrdersController()).getOrders();
                }),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood, size: 30),
            label: 'Items',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long, size: 30),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, size: 30),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        activeColor: primaryColor,
        inactiveColor: bodyTextColor,
        onTap: _onItemTapped,
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Profile Screen'),
    );
  }
}
