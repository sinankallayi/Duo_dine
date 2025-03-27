import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodly_ui/data.dart';
import 'package:foodly_ui/models/menu_items_model.dart';
import 'package:foodly_ui/screens/addToOrder/add_to_order_controller.dart';
import 'package:foodly_ui/screens/auth/components/show_login_bottomsheet.dart';
import 'package:get/get.dart';

import '/constants.dart';
import 'components/info.dart';

// ignore: must_be_immutable
class AddToOrderScrreen extends GetView<AddToOrderController> {
  final MenuItemModel item;
  AddToOrderScrreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    Get.put(AddToOrderController());
    controller.item = item;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              backgroundColor: Colors.black.withOpacity(0.5),
              padding: EdgeInsets.zero,
            ),
            child: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Info(item: item),
              const SizedBox(height: defaultPadding),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const RequiredSectionTitle(title: "Choice of top Cookie"),
                    // const SizedBox(height: defaultPadding),
                    // ...List.generate(
                    //   choiceOfTopCookies.length,
                    //   (index) => RoundedCheckboxListTile(
                    //     isActive: index == choiceOfTopCookie,
                    //     text: choiceOfTopCookies[index],
                    //     press: () {
                    //       choiceOfTopCookie = index;
                    //     },
                    //   ),
                    // ),
                    // const SizedBox(height: defaultPadding),
                    // const RequiredSectionTitle(
                    //     title: "Choice of Bottom Cookie"),
                    // const SizedBox(height: defaultPadding),
                    // ...List.generate(
                    //   choiceOfTopCookies.length,
                    //   (index) => RoundedCheckboxListTile(
                    //     isActive: index == choiceOfBottomCookie,
                    //     text: choiceOfTopCookies[index],
                    //     press: () {
                    //       choiceOfBottomCookie = index;
                    //     },
                    //   ),
                    // ),
                    // const SizedBox(height: defaultPadding),
                    // // Num of item
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              if (controller.numOfItems.value > 1) {
                                controller.numOfItems.value--;
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: EdgeInsets.zero,
                            ),
                            child: const Icon(Icons.remove, color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                          child: Obx(() => Text(controller.numOfItems.toString().padLeft(2, "0"),
                              style: Theme.of(context).textTheme.titleLarge)),
                        ),
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              if (controller.numOfItems.value < 20) {
                                controller.numOfItems.value++;
                              } else {
                                Fluttertoast.showToast(msg: "You can't order more than 20 items");
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: EdgeInsets.zero,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: defaultPadding),
                    ElevatedButton(
                      onPressed: () {
                        if (user == null) {
                          showLoginBottomSheet(context);
                          return;
                        } else {
                          controller.addOrder();
                        }
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const OrderDetailsScreen(),
                        //   ),
                        // );
                      },
                      child: Obx(() => Text(
                          "Add to Order (₹${(item.price * controller.numOfItems.value).toStringAsFixed(2)})")),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: defaultPadding)
            ],
          ),
        ),
      ),
    );
  }

  List<String> choiceOfTopCookies = [
    "Choice of top Cookie",
    "Cookies and Cream",
    "Funfetti",
    "M and M",
    "Red Velvet",
    "Peanut Butter",
    "Snickerdoodle",
    "White Chocolate Macadamia",
  ];
}
