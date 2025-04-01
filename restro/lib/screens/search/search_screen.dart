import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodly_ui/screens/details/details_screen.dart';
import 'package:foodly_ui/screens/search/controller/search_screen_controller.dart';
import 'package:get/get.dart';

import '../../components/cards/big/restaurant_info_big_card.dart';
import '../../components/scalton/big_card_scalton.dart';
import '../../constants.dart';

class SearchScreen extends GetView<SearchScreenController> {
  const SearchScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(SearchScreenController());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: defaultPadding),
              Text('Search', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: defaultPadding),
              // Inline search field integrated directly
              Form(
                child: TextFormField(
                  onChanged: (value) async {
                    // await Future.delayed(const Duration(milliseconds: 600));
                    if (value.length >= 3) {
                      controller.searchRestaurants(value);
                    }
                  },
                  onFieldSubmitted: (value) {
                    controller.searchRestaurants(value);
                  },
                  validator: requiredValidator,
                  style: Theme.of(context).textTheme.labelLarge,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: "Search on foodly",
                    contentPadding: kTextFieldPadding,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        'assets/icons/search.svg',
                        colorFilter: const ColorFilter.mode(
                          bodyTextColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              // Replaced static Text with Obx-wrapped Text for showing dynamic search header.
              Obx(() => Text(
                    controller.showSearchResult.value
                        ? "Search Results"
                        : "Top Restaurants",
                    style: Theme.of(context).textTheme.titleLarge,
                  )),
              const SizedBox(height: defaultPadding),
              // Wrap ListView.builder in Obx to react to state changes.
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: controller.isLoading.value
                        ? 2
                        : controller.restaurants.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: defaultPadding),
                      child: controller.isLoading.value
                          ? const BigCardScalton()
                          : RestaurantInfoBigCard(
                              id: controller.restaurants[index].id,
                              name: controller.restaurants[index].name,
                              address: controller.restaurants[index].address,
                              location: controller.restaurants[index].location,
                              tags: controller.restaurants[index].tags,
                              description:
                                  controller.restaurants[index].description,
                              approved: controller.restaurants[index].approved,
                              phone: controller.restaurants[index].phone,
                              rating: controller.restaurants[index].rating,
                              createdAt:
                                  controller.restaurants[index].createdAt,
                              updatedAt:
                                  controller.restaurants[index].updatedAt,
                              images: [],
                              press: () {
                                Get.to(() => DetailsScreen(
                                    restaurant: controller.restaurants[index]));
                              },
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
