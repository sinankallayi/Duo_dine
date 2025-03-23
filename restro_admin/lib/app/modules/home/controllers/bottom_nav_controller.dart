import 'package:get/get.dart';

class BottomNavController extends GetxController {
  RxInt selectedIndex = 0.obs; // Stores the current index

  void changeTab(int index) {
    selectedIndex.value = index; // Updates index when a tab is clicked
  }
}
