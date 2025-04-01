import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:foodly_ui/data.dart';
import 'package:foodly_ui/screens/details/details_screen.dart';
import 'package:foodly_ui/screens/home/home_controller.dart';
import 'package:foodly_ui/screens/search/search_screen.dart';
import 'package:get/get.dart';

import '../../components/cards/big/restaurant_info_big_card.dart';
import '../../components/section_title.dart';
import '../../constants.dart';
import '../../functions/color_utils.dart';
import 'components/promotion_banner.dart';

class HomeScreen extends GetView<HomeScreenController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeScreenController());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Duo Dine",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        )
            .animate(onPlay: (controller) => controller.repeat())
            .shimmer(duration: 1200.ms, color: const Color(0xFF80DDFF))
            .animate() // this wraps the previous Animate in another Animate
            .fadeIn(duration: 1200.ms, curve: Curves.easeOutQuad)
            .slide(),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(children: [
              if (user != null)
                const Icon(
                  CupertinoIcons.person,
                  color: Colors.black,
                ),
              Text(
                user?.name ?? "Guest",
                style: Theme.of(context).textTheme.bodyLarge,
              )
            ]),
          )
        ],
      ),
      // appBar: AppBar(
      //   // leading: const SizedBox(),
      //   title: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       // Text(
      //       //   "Delivery to".toUpperCase(),
      //       //   style: Theme.of(context)
      //       //       .textTheme
      //       //       .bodySmall!
      //       //       .copyWith(color: primaryColor),
      //       // ),
      //       // Text(
      //       //   "${place}",
      //       //   style: TextStyle(color: Colors.black),
      //       // )
      //     ],
      //   ),
      //   actions: [
      //     // TextButton(
      //     //   onPressed: () {
      //     //     Navigator.push(
      //     //       context,
      //     //       MaterialPageRoute(
      //     //         builder: (context) => const FilterScreen(),
      //     //       ),
      //     //     );
      //     //   },
      //     //   child: Text(
      //     //     "Filter",
      //     //     style: Theme.of(context).textTheme.bodyLarge,
      //     //   ),
      //     // ),
      //   ],
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: defaultPadding),
              // ads are shown here
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              //   child: AdDisplay(images: demoBigImages),
              // ),
              // const SizedBox(height: defaultPadding * 2),
              // SectionTitle(
              //   title: "Featured Partners",
              //   press: () => Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => const FeaturedScreen(),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: defaultPadding),
              // List of Partners
              // const MediumCardList(),
              // const SizedBox(height: 20),
              // Banner
              const PromotionBanner(),
              const SizedBox(height: 20),
              Obx(() {
                String intro = controller.intro.value;
                return intro.isEmpty
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: controller.generateIntroText,
                          child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: controller.introBg.value.withAlpha(30),
                                border: Border.all(width: 3, color: controller.introBg.value),
                                borderRadius: const BorderRadius.all(Radius.circular(12)),
                              ),
                              child: Text(
                                intro,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                              )
                                  .animate(target: controller.introLoading.value ? 1 : 0)
                                  .fade(end: 0.5)),
                        ),
                      );
              }),
              // SectionTitle(
              //   title: "Best Pick",
              //   press: () => Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => const FeaturedScreen(),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 16),
              // const MediumCardList(),
              // const SizedBox(height: 20),
              SectionTitle(
                  title: "All Restaurants",
                  press: () {
                    Get.to(const SearchScreen());
                  }),
              const SizedBox(height: 16),

              // Demo list of Big Cards...List.generate(
              // For demo we use 4 items

              Obx(() => ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.restaurants.length,
                    itemBuilder: (context, index) {
                      return RestaurantInfoBigCard(
                        id: controller.restaurants[index].id,
                        name: controller.restaurants[index].name,
                        address: controller.restaurants[index].address,
                        location: controller.restaurants[index].location,
                        tags: controller.restaurants[index].tags,
                        description: controller.restaurants[index].description,
                        approved: controller.restaurants[index].approved,
                        phone: controller.restaurants[index].phone,
                        rating: controller.restaurants[index].rating,
                        createdAt: controller.restaurants[index].createdAt,
                        updatedAt: controller.restaurants[index].updatedAt,
                        images: [],
                        press: () {
                          Get.to(() => DetailsScreen(restaurant: controller.restaurants[index]));
                        },
                      );
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
