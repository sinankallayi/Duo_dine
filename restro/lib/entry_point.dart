import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodly_ui/data.dart';
import 'package:foodly_ui/screens/auth/sign_in_screen.dart';
import 'package:foodly_ui/screens/orderDetails/order_details_controller.dart';
import 'package:foodly_ui/screens/search/controller/search_screen_controller.dart';
import 'package:get/get.dart';
import 'constants.dart';
import 'screens/home/home_screen.dart';
import 'screens/orderDetails/order_details_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/search/search_screen.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  // Bydefault first one is selected
  int _selectedIndex = 0;

  // List of nav items
  final List<Map<String, dynamic>> _navitems = [
    {"icon": "assets/icons/home.svg", "title": "Home"},
    {"icon": "assets/icons/search.svg", "title": "Search"},
    {"icon": "assets/icons/order.svg", "title": "Orders"},
    {"icon": "assets/icons/profile.svg", "title": "Profile"},
  ];

// Screens
  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const OrderDetailsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    /// If you set your home screen as first screen make sure call [SizeConfig().init(context)]
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: CupertinoTabBar(
        onTap: (value) {
          print(value);

          if (value == 2) {
            if (user == null) {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    padding: const EdgeInsets.all(20.0),
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Please sign in to continue',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignInScreen()),
                            );
                          },
                          child: const Text('Sign In'),
                        ),
                      ],
                    ),
                  );
                },
              );
              return;
            }
            // show search screen
            Get.put(OrderDetailsController()).getCartItems();
            Get.put(OrderDetailsController()).getOrders();
          }
          if (value == 1) {
            // show profile screen
            Get.put(SearchScreenController()).getSearchResult('');
          }
          if ((value == 2 || value == 3) && user == null) {
            // show bottom modal to sign in
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.all(20.0),
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Please sign in to continue',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignInScreen()),
                          );
                        },
                        child: const Text('Sign In'),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            setState(() {
              _selectedIndex = value;
            });
          }
        },
        currentIndex: _selectedIndex,
        activeColor: primaryColor,
        inactiveColor: bodyTextColor,
        items: List.generate(
          _navitems.length,
          (index) => BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _navitems[index]["icon"],
              height: 30,
              width: 30,
              colorFilter: ColorFilter.mode(
                  index == _selectedIndex ? primaryColor : bodyTextColor,
                  BlendMode.srcIn),
            ),
            label: _navitems[index]["title"],
          ),
        ),
      ),
    );
  }
}
