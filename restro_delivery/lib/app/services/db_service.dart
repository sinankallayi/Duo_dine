import 'dart:developer';

import 'package:appwrite/appwrite.dart';

import '../data/constants.dart';

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
}
