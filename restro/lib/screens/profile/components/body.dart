import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodly_ui/data.dart';
import 'package:foodly_ui/functions/auth.dart';
import 'package:foodly_ui/screens/favorites/favorites_screen.dart';
import 'package:foodly_ui/screens/findRestaurants/find_restaurants_screen.dart';
import 'package:foodly_ui/screens/splash/splash_view.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';
import '../../../constants.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: defaultPadding),
              Text("Account Settings", style: Theme.of(context).textTheme.headlineMedium),
              Text(
                "Update your settings like notifications, payments, profile edit etc.",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ProfileMenuCard(
                icon: CupertinoIcons.heart,
                title: "Favorites",
                subTitle: "Order your favorite items",
                press: () {
                  log("Pressed favorites");
                  Get.to(() => const FavoritesScreen());
                },
              ),
              ProfileMenuCard(
                icon: CupertinoIcons.person,
                title: "Profile Information",
                subTitle: "Change your account information",
                press: () {},
              ),
              ProfileMenuCard(
                icon: CupertinoIcons.lock,
                title: "Change Password",
                subTitle: "Change your password",
                press: () {},
              ),
              ProfileMenuCard(
                icon: CupertinoIcons.square_on_square,
                title: "Switch to restaurant",
                subTitle: "Switch to your restaurant account",
                press: () async {
                  await localStorage.write('isCustomer', false);
                  isCustomer = false;
                  Get.offAll(const SplashView());
                  // Restart.restartApp();
                },
              ),
              ProfileMenuCard(
                icon: CupertinoIcons.location,
                title: "Locations",
                subTitle: "Add or remove your delivery locations",
                press: () {
                  // FindRestaurantsScreen();
                  Get.to(() => const FindRestaurantsScreen());
                },
              ),
              // logout
              ProfileMenuCard(
                icon: CupertinoIcons.square_arrow_left,
                title: "Logout",
                subTitle: "Logout from your account",
                press: () {
                  // show bottom modal to confirm logout
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Logout",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text("Are you sure you want to logout?"),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await logout();
                                    Get.offAll(const SplashView());
                                  },
                                  child: const Text(
                                    "Logout",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              // ProfileMenuCard(
              //   svgSrc: "assets/icons/fb.svg",
              //   title: "Add Social Account",
              //   subTitle: "Add Facebook, Twitter etc ",
              //   press: () {},
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileMenuCard extends StatelessWidget {
  const ProfileMenuCard({
    super.key,
    this.title,
    this.subTitle,
    this.icon,
    this.press,
  });

  final String? title, subTitle;
  final IconData? icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        onTap: press,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.black.withAlpha(130),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title!,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subTitle!,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 14,
                        color: titleColor.withOpacity(0.54),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios_outlined,
                size: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
