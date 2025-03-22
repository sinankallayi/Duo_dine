import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurants'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.restaurants.isEmpty) {
          return const Center(child: Text('No restaurants available'));
        } else {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor:
                          WidgetStateProperty.all(Colors.blueGrey[400]),
                      headingTextStyle: TextStyle(color: Colors.white),
                      columns: const [
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Location')),
                        DataColumn(label: Text('Rating')),
                        DataColumn(label: Text('Phone')),
                        DataColumn(label: Text('Approval')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: controller.restaurants.map((restaurant) {
                        return DataRow(
                          color: WidgetStateProperty.all(
                            restaurant.approved
                                ? Colors.lightGreen.withOpacity(0.2)
                                : Colors.red.withOpacity(0.2),
                          ),
                          cells: [
                            DataCell(Text(restaurant.name)),
                            DataCell(Text(restaurant.location)),
                            DataCell(Text(restaurant.rating.toString())),
                            DataCell(Text(restaurant.phone)),
                            DataCell(
                              Container(
                                color: restaurant.approved
                                    ? Colors.lightGreen
                                    : Colors.red,
                                child: Text(
                                  restaurant.approved
                                      ? 'Approved'
                                      : 'Not Approved',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            DataCell(Row(
                              children: [
                                // approve button
                                TextButton(
                                    onPressed: () {
                                      controller.approve(restaurant.id);
                                    },
                                    child: const Text('Approve')),

                                // reject button
                                TextButton(
                                    onPressed: () {
                                      controller.reject(restaurant.id);
                                    },
                                    child: const Text('Reject')),

                                // delete button
                                TextButton(
                                    onPressed: () {
                                      controller.delete(restaurant.id);
                                    },
                                    child: const Text('Delete')),
                              ],
                            )),
                          ],
                        );
                      }).toList(),
                    ),
                  )),
            ),
          );
        }
      }),
    );
  }
}
