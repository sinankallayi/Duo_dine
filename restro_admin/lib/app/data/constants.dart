import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

Client? client;
User? user;
Account account = Account(client!);
Databases databases = Databases(client!);

// databse
const dbId = '67dd045f0027aa53f550';

// collections
const restaurantCollection = '679351de0007535ff696';
const itemsCollection = '67935bfd001541bc5ae2';
const cartCollection = "67935e61002d2eb9cece";
const userCollection = "67935d0b000fcda8cb7f";
const paymentCollection = "67cd39f90020db666b4f";
