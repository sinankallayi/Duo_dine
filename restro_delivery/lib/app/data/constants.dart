import 'dart:ui';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';


// clolors that we use in our app
const titleColor = Color(0xFF010F07);
const primaryColor = Color(0xFF22A45D);
const accentColor = Color(0xFFEF9920);
const bodyTextColor = Color(0xFF868686);
const inputColor = Color(0xFFFBFBFB);

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
// const userCollection = "67935d0b000fcda8cb7f";
const orderItemsCollection = "67935e14001fe833d665";
const ordersCollection = "67935cf2002174bad91d";
const deliveryPersonsCollection = "67c96b630024ab1bf027";
