import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

Client? client;
User? user;
Account account = Account(client!);
Databases databases = Databases(client!);

// databse
const dbId = '67dd045f0027aa53f550';

// collections
const restaurantCollection = '67dd048f000c39c77100';
const itemsCollection = '67dd04a6002e67174a99';
const cartCollection = "67dd04cd00213c02a849";
const userCollection = "67dd04dd002d7a8904c0";
