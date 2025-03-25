import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/functions/image.dart';
import 'package:foodly_ui/screens/Restaurent/home/controllers/items_controller.dart';
import 'package:get/get.dart';
import 'dart:io';

class ItemsScreen extends GetView<ItemsScreenController> {
  const ItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.clear();
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: _BottomModalAddItem(controller: controller),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            left: defaultPadding,
            right: defaultPadding,
            bottom: defaultPadding),
        child: _buildItemsList(),
      ),
    );
  }

  Widget _buildItemsList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.items.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/Illustrations/no_data.svg', height: 100),
              const SizedBox(height: 10),
              const Text('No Item Found', style: TextStyle(fontSize: 18)),
            ],
          ),
        );
      }
      // Using CustomScrollView and slivers to avoid RenderFlex overflow.
      return CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Items',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => controller.loadItems(),
                  child: const Text('View All'),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 10),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, // Adjust the number of columns as needed
                childAspectRatio: 2, // Adjust the aspect ratio as needed
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = controller.items[index]!;
                  return Card(
                    elevation: 2,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              Text(item.category),
                              const SizedBox(height: 8),
                              Text("₹${item.price}"),
                              const Spacer(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(50, 30),
                                    ),
                                    onPressed: () {
                                      controller
                                          .viewItem(getImageUrl(item.imageId));
                                    },
                                    child: const Text(
                                      'View',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(50, 30),
                                    ),
                                    onPressed: () {
                                      controller.editItem(item);
                                    },
                                    child: const Text(
                                      'Edit',
                                      style: TextStyle(color: Colors.orange),
                                    ),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(50, 30),
                                    ),
                                    onPressed: () {
                                      controller.deleteItem(item);
                                    },
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Show the indicator in the top right based on availability.
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                              color: item.availability
                                  ? const Color(0xff22B55A)
                                  : const Color(0xffED4343),
                              borderRadius: BorderRadius.circular(90),
                            ),
                            child: Text(
                              item.availability ? 'Available' : 'Unavailable',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: controller.items.length,
              ),
            ),
          ),
        ],
      );
    });
  }
}

// Bottom modal widget for adding a new item.
class _BottomModalAddItem extends StatelessWidget {
  const _BottomModalAddItem({required this.controller});

  final ItemsScreenController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(
              controller: controller.dishNameController,
              label: 'Dish Name',
              onChanged: (value) => controller.dishName.value = value,
            ),
            _buildTextField(
              controller: controller.categoryController,
              label: 'Category',
              onChanged: (value) => controller.category.value = value,
            ),
            _buildTextField(
              controller: controller.priceController,
              label: 'Price',
              onChanged: (value) => controller.price.value = value,
              keyboardType: TextInputType.number,
            ),
            _buildStatusDropdown(),
            const SizedBox(height: 10),
            _buildImagePicker(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                controller.addItem();
                Navigator.pop(context);
              },
              child: const Text('Add Menu Item'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required ValueChanged<String> onChanged,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      decoration: InputDecoration(labelText: label),
      onChanged: onChanged,
      keyboardType: keyboardType,
      controller: controller,
    );
  }

  Widget _buildStatusDropdown() {
    return Obx(
      () {
        return DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Status'),
          value: controller.status.value,
          items: const [
            DropdownMenuItem(value: 'available', child: Text('Available')),
            DropdownMenuItem(value: 'unavailable', child: Text('Unavailable')),
          ],
          onChanged: (value) {
            if (value != null) {
              controller.status.value = value;
            }
          },
        );
      },
    );
  }

  Widget _buildImagePicker() {
    return Obx(
      () {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                controller.imagePath.value = await pickImage();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey,
                ),
                width: 100,
                height: 100,
                clipBehavior: Clip.hardEdge,
                child: controller.imagePath.value.isEmpty
                    ? const Icon(Icons.add_a_photo, color: Colors.white)
                    : Image.file(
                        File(controller.imagePath.value),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(controller.dishName.value),
                Text(controller.category.value),
                Text(controller.price.value),
                Text(controller.status.value),
              ],
            ),
          ],
        );
      },
    );
  }
}
