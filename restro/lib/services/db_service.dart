import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:uuid/uuid.dart';

import '../constants.dart';
import '../models/menu_items_model.dart';

class DbService {
  final Client client = Client();
  late final Account account;
  late final Databases db;
  late final Realtime realtime;

  String databaseId = dbId;

  DbService() {
    log("Initialising Db service");
    client.setProject(projectId);
    account = Account(client);
    db = Databases(client);
    realtime = Realtime(client);
  }

  Future<String?> getUserId() async {
    try {
      final user = await account.get();
      return user.$id;
    } catch (e) {
      print("Error getting user: $e");
      return null;
    }
  }

  Future<List<MenuItemModel>> getAvailableItemsByIds(List<String> itemIds) async {
    if (itemIds.isEmpty) return [];
    final result =
        await db.listDocuments(databaseId: dbId, collectionId: itemsCollection, queries: [
      Query.equal('\$id', itemIds),
      Query.equal('availability', true),
    ]);

    return result.documents.map((doc) => MenuItemModel.fromJson(doc.data)).toList();
  }

  Future<List<MenuItemModel>> getAvailableItemsForRestaurant(String restaurantId) async {
    log("getAvailableItemsForRestaurant");
    final result =
        await db.listDocuments(databaseId: dbId, collectionId: itemsCollection, queries: [
      Query.equal("restaurant", restaurantId),
      Query.equal('availability', true),
    ]);

    return result.documents.map((doc) => MenuItemModel.fromJson(doc.data)).toList();
  }

  Future<List<String>> getUserFavoriteItemIds(String userId) async {
    final result = await db.listDocuments(
      databaseId: databaseId,
      collectionId: favoritesCollection,
      queries: [Query.equal('userId', userId)],
    );

    return result.documents.map((doc) => doc.data['itemId'] as String).toList();
  }

  Future<void> toggleFavorite(String userId, String itemId, bool isFavorite) async {
    const Uuid uuid = Uuid();
    final String documentId = uuid.v5(Namespace.url.value, '$userId:$itemId');

    if (isFavorite) {
      await db.deleteDocument(
        databaseId: databaseId,
        collectionId: favoritesCollection,
        documentId: documentId,
      );
    } else {
      await db.createDocument(
        databaseId: databaseId,
        collectionId: favoritesCollection,
        documentId: documentId,
        data: {'userId': userId, 'itemId': itemId},
      );
    }
  }
}
