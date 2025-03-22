import 'package:appwrite/appwrite.dart';
import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/data.dart';
import 'package:foodly_ui/models/restaurant_model.dart';

checkApproval() async {
  // check if the user is approved
  String approvalStatus = 'pending';
  try {
    var document = await db.getDocument(
      databaseId: dbId,
      collectionId: restaurantCollection,
      documentId: user!.$id,
    );

    restaurant.value = Restaurant.fromJson(document.data);

    if (document.data['approved'] == true) {
      approvalStatus = 'approved';
    }
  } on AppwriteException catch (e) {
    print('Error: ${e.message}');
    // Document with the requested ID could not be found.
    if (e.message == 'Document with the requested ID could not be found.') {
      // User is not approved
      approvalStatus = 'not registered';
    }
  }

  return approvalStatus;
}
