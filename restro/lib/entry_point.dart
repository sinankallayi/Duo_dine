import 'package:flutter/material.dart';
import 'package:foodly_ui/components/navigation/bottom_nav_bar.dart';
import 'package:foodly_ui/data.dart';
import 'package:foodly_ui/screens/auth/components/show_login_bottomsheet.dart';
import 'package:foodly_ui/screens/orderDetails/order_details_controller.dart';
import 'package:foodly_ui/screens/search/controller/search_screen_controller.dart';
import 'package:get/get.dart';

import 'screens/home/home_screen.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  Widget _currentScreen = const HomeScreen();

  void _onNavItemSelected(int value, Widget screen) {
    const Home = 0;
    const Search = 1;
    const Order = 2;
    const Profile = 3;

    print(value);

    if (value == Order) {
      if (user == null) {
        showLoginBottomSheet(context);
        ;
        return;
      }
      Get.put(OrderDetailsController()).getCartItems();
      Get.put(OrderDetailsController()).getOrders();
    }
    if (value == Search) {
      Get.put(SearchScreenController()).getSearchResult('');
    }
    if ((value == Order || value == Profile) && user == null) {
      showLoginBottomSheet(context);
    } else {
      setState(() {
        _currentScreen = screen;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    /// If you set your home screen as first screen make sure call [SizeConfig().init(context)]
    return Scaffold(
      body: _currentScreen,
      bottomNavigationBar: BottomNavBar(onItemSelected: _onNavItemSelected),
    );
  }
}
