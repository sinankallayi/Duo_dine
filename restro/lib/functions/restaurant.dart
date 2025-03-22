import 'package:appwrite/appwrite.dart';
import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/data.dart';
import 'package:foodly_ui/screens/Restaurent/waiting/approval_screen.dart';
import 'package:get/get.dart';

Future<void> registerRestaurant({
  required String name,
  required String address,
  required String phone,
  required String location,
  required String tags,
  required String description,
}) async {
  final data = {
    'name': name,
    'address': address,
    'phone': phone,
    'location': location,
    'tags': tags,
    'description': description,
  };
  try {
    await db.createDocument(
      databaseId: dbId,
      collectionId: restaurantCollection,
      documentId: user!.$id,
      data: data,
    );
  } on AppwriteException catch (e) {
    if (e.code == 409) {
      print('Document already exists');
      Get.offAll(() => const ApprovalScreen());
    } else {
      print('sinu,Error: ${e.message}');
    }
  }
}

Future<void> addItemToServer({
  required String dishName,
  required String category,
  required double price,
  required bool availability,
  required String restaurantID,
  required String imageId,
}) async {
  final data = {
    'name': dishName,
    'category': category,
    'price': price,
    'restaurant': restaurantID,
    'availability': availability,
    'imageId': imageId,
  };
  try {
    await db.createDocument(
      databaseId: dbId,
      collectionId: itemsCollection,
      documentId: ID.unique(),
      data: data,
    );
    print('Item added successfully');
  } on AppwriteException catch (e) {
    print('Error: ${e.message}');
  }
}

updateItemToServer({
  required String id,
  required String dishName,
  required String category,
  required double price,
  required bool availability,
  required String restaurantID,
  required String imageId,
}) async {
  final data = {
    'name': dishName,
    'category': category,
    'price': price,
    'restaurant': restaurantID,
    'availability': availability,
    'imageId': imageId,
  };
  try {
    await db.updateDocument(
      databaseId: dbId,
      collectionId: itemsCollection,
      documentId: id,
      data: data,
    );
    print('Item updated successfully');
  } on AppwriteException catch (e) {
    print('Error: ${e.message}');
  }
}
