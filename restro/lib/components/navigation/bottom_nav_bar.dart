import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/screens/home/home_screen.dart';
import 'package:foodly_ui/screens/search/search_screen.dart';
import 'package:foodly_ui/screens/orderDetails/order_details_screen.dart';
import 'package:foodly_ui/screens/profile/profile_screen.dart';

class BottomNavBar extends StatefulWidget {
  final Function(int, Widget) onItemSelected;

  const BottomNavBar({
    super.key,
    required this.onItemSelected,
  });

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _navItems = const [
    {"icon": "assets/icons/home.svg", "title": "Home"},
    {"icon": "assets/icons/search.svg", "title": "Search"},
    {"icon": "assets/icons/order.svg", "title": "Orders"},
    {"icon": "assets/icons/profile.svg", "title": "Profile"},
  ];

  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const OrderDetailsScreen(),
    const ProfileScreen(),
  ];

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onItemSelected(index, _screens[index]);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabBar(
      onTap: _onTap,
      currentIndex: _selectedIndex,
      activeColor: primaryColor,
      inactiveColor: bodyTextColor,
      items: List.generate(
        _navItems.length,
        (index) => BottomNavigationBarItem(
          icon: SvgPicture.asset(
            _navItems[index]["icon"],
            height: 30,
            width: 30,
            colorFilter: ColorFilter.mode(
              index == _selectedIndex ? primaryColor : bodyTextColor,
              BlendMode.srcIn,
            ),
          ),
          label: _navItems[index]["title"],
        ),
      ),
    );
  }
}
