import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodly_ui/models/restaurant_model.dart';
import 'package:foodly_ui/screens/details/details_controller.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import 'components/featured_items.dart';
import 'components/iteams.dart';
import 'components/restaurrant_info.dart';

class DetailsScreen extends GetView<DetailsController> {
  final Restaurant restaurant;
  const DetailsScreen({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    Get.put(DetailsController());
    controller.restaurant = restaurant;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: SvgPicture.asset("assets/icons/share.svg"),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: defaultPadding / 2),
                      RestaurantInfo(restaurant: restaurant),
                      const SizedBox(height: defaultPadding),
                      FeaturedItems(),
                      Items()
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
