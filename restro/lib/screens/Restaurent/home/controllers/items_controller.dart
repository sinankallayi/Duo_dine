import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:foodly_ui/components/loading_widget.dart';
import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/data.dart';
import 'package:foodly_ui/functions/image.dart';
import 'package:foodly_ui/functions/restaurant.dart';
import 'package:foodly_ui/models/menu_items_model.dart';
import 'package:get/get.dart';

class ItemsScreenController extends GetxController {
  TextEditingController dishNameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  final RxString dishName = ''.obs;
  final RxString category = ''.obs;
  final RxString price = ''.obs;
  final RxString status = 'available'.obs;
  final RxString imagePath = ''.obs;
  final RxBool isLoading = false.obs;

  RxList<MenuItemModel?> items = <MenuItemModel?>[].obs;

  void setImagePath(String path) {
    imagePath.value = path;
  }

  void addItem() {
    if (dishName.value.isEmpty ||
        category.value.isEmpty ||
        price.value.isEmpty) {
      Get.snackbar('Error', 'Please fill all the fields',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (imagePath.value.isEmpty) {
      Get.snackbar('Error', 'Please upload an image',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    Get.showOverlay(
      asyncFunction: () async {
        String? imageId =
            await uploadImage(imagePath: imagePath.value, name: dishName.value);
        if (imageId != null) {
          debugPrint('Image uploaded: $imageId');
          await addItemToServer(
            dishName: dishName.value,
            category: category.value,
            price: double.parse(price.value),
            availability: status.value == 'available',
            restaurantID: restaurant.value!.id,
            imageId: imageId,
          );
          clear();
          loadItems();
          Get.back();
        } else {
          Get.back();
          Get.snackbar('Error', 'Error uploading image',
              snackPosition: SnackPosition.BOTTOM);
        }
      },
      loadingWidget: loadingWidget(),
    );
  }

  void clear() {
    dishNameController.clear();
    categoryController.clear();
    priceController.clear();
    dishName.value = '';
    category.value = '';
    price.value = '';
    status.value = 'available';
    imagePath.value = '';
  }

  @override
  void onInit() {
    loadItems();
    super.onInit();
  }

  Future<void> loadItems() async {
    isLoading.value = true;
    try {
      debugPrint('Loading items');
      await db.listDocuments(
        databaseId: dbId,
        collectionId: itemsCollection,
        queries: [Query.equal('restaurant', restaurant.value!.id)],
      ).then((value) {
        items.clear();
        for (var item in value.documents) {
          items.add(MenuItemModel.fromJson(item.data));
        }
      });
    } catch (e) {
      debugPrint('Error loading items: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void deleteItem(MenuItemModel menuItemModel) {
    // show alert dialog
    Get.defaultDialog(
      title: 'Delete Item ?',
      middleText: 'Are you sure you want to delete this item?',
      textCancel: 'Cancel',
      textConfirm: 'Delete',
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.black,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        Get.showOverlay(
          asyncFunction: () async {
            try {
              await db.deleteDocument(
                databaseId: dbId,
                collectionId: itemsCollection,
                documentId: menuItemModel.$id,
              );
              await deleteImage(menuItemModel.imageId);
              loadItems();
            } catch (e) {
              Get.snackbar('Error', 'Error deleting item',
                  snackPosition: SnackPosition.BOTTOM);
            }
          },
          loadingWidget: loadingWidget(),
        );
      },
    );
  }

  void editItem(MenuItemModel menuItemModel) {
    status.value = menuItemModel.availability ? 'available' : 'unavailable';
    dishName.value = menuItemModel.name;
    category.value = menuItemModel.category;
    price.value = menuItemModel.price.toString();
    dishNameController.text = menuItemModel.name;
    categoryController.text = menuItemModel.category;
    priceController.text = menuItemModel.price.toString();
    imagePath.value = '';

    showModalBottomSheet(
      context: Get.context!,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Form fields for editing item
                TextField(
                  controller: dishNameController,
                  onChanged: (value) => dishName.value = value,
                  decoration: const InputDecoration(labelText: 'Dish Name'),
                ),
                TextField(
                  controller: categoryController,
                  onChanged: (value) => category.value = value,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                TextField(
                  controller: priceController,
                  onChanged: (value) => price.value = value,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                // New row: Dropdown for status and image picker together
                Row(
                  spacing: 10,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        String path = await pickImage();
                        if (path.isNotEmpty) {
                          setImagePath(path);
                        }
                      },
                      child: Obx(
                        () => imagePath.value.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.file(
                                  File(imagePath.value),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  // 'https://cloud.appwrite.io/v1/storage/buckets/$itemsBucketId/files/${menuItemModel.imageId}/view?project=restro',
                                  getImageUrl(menuItemModel.imageId),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                    Expanded(
                      child: Obx(
                        () => DropdownButton<String>(
                        value: status.value,
                        onChanged: (String? value) {
                          status.value = value!;
                        },
                        isExpanded: true,
                        items: <String>['available', 'unavailable']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    )),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    updateItem(menuItemModel);
                    Navigator.pop(context);
                  },
                  child: const Text('Update'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void updateItem(MenuItemModel menuItemModel) {
    if (dishName.value.isEmpty ||
        category.value.isEmpty ||
        price.value.isEmpty) {
      Get.snackbar('Error', 'Please fill all the fields',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    Get.showOverlay(
      asyncFunction: () async {
        String? imageId;
        if (imagePath.value.isNotEmpty) {
          imageId = await uploadImage(
            imagePath: imagePath.value,
            name: dishName.value,
          );
          if (imageId != null) {
            debugPrint('Image uploaded: $imageId');
            await deleteImage(menuItemModel.imageId);
          } else {
            Get.back();
            Get.snackbar('Error', 'Error uploading image',
                snackPosition: SnackPosition.BOTTOM);
            return;
          }
        }

        await updateItemToServer(
          id: menuItemModel.$id,
          dishName: dishName.value,
          category: category.value,
          price: double.parse(price.value),
          availability: status.value == 'available',
          restaurantID: restaurant.value!.id,
          imageId: imageId ?? menuItemModel.imageId,
        );
        clear();
        loadItems();
        Get.back();
      },
      loadingWidget: loadingWidget(),
    );
  }

  void viewItem(String imageUrl) {
    showImageViewer(
      Get.context!,
      NetworkImage(imageUrl),
      backgroundColor: Colors.black.withOpacity(0.5),
    );
  }
}
