import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get_storage/get_storage.dart';

// clolors that we use in our app
const titleColor = Color(0xFF010F07);
const primaryColor = Color(0xFF22A45D);
const accentColor = Color(0xFFEF9920);
const bodyTextColor = Color(0xFF868686);
const inputColor = Color(0xFFFBFBFB);

const double defaultPadding = 16;
const Duration kDefaultDuration = Duration(milliseconds: 250);

const TextStyle kButtonTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 14,
  fontWeight: FontWeight.bold,
);

const EdgeInsets kTextFieldPadding = EdgeInsets.symmetric(
  horizontal: defaultPadding,
  vertical: defaultPadding,
);

// Text Field Decoration
const OutlineInputBorder kDefaultOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(6)),
  borderSide: BorderSide(
    color: Color(0xFFF3F2F2),
  ),
);

const InputDecoration otpInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.zero,
  counterText: "",
  errorStyle: TextStyle(height: 0),
);

const kErrorBorderSide = BorderSide(color: Colors.red, width: 1);

// Validator
final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'Password is required'),
  MinLengthValidator(8, errorText: 'Password must be at least 8 digits long'),
  PatternValidator(r'(?=.*?[#?!@$%^&*-/])',
      errorText: 'Passwords must have at least one special character')
]);

final emailValidator = MultiValidator([
  RequiredValidator(errorText: 'Email is required'),
  EmailValidator(errorText: 'Enter a valid email address')
]);

final requiredValidator =
    RequiredValidator(errorText: 'This field is required');

final matchValidator = MatchValidator(errorText: 'passwords do not match');

final phoneNumberValidator = MinLengthValidator(10,
    errorText: 'Phone Number must be at least 10 digits long');

// Common Text
final Center kOrText = Center(
    child: Text("Or", style: TextStyle(color: titleColor.withOpacity(0.7))));

const projectId = '67dc5f7e003032d8838b';
// Client
//Client client = Client().setProject('restro');
Client client = Client().setProject(projectId);
Account account = Account(client);
Databases db = Databases(client);
Storage storage = Storage(client);
Messaging messaging = Messaging(client);
Functions functions = Functions(client);

// local storage
final localStorage = GetStorage();

// databse
const dbId = '67dd045f0027aa53f550';
const funId = "67cd58e6002f3c0a38f4";

// collections
const restaurantCollection = '679351de0007535ff696';
const itemsCollection = '67935bfd001541bc5ae2';
const cartCollection = "67935e61002d2eb9cece";
// const userCollection = "67935d0b000fcda8cb7f";
const orderItemsCollection = "67935e14001fe833d665";
const ordersCollection = "67935cf2002174bad91d";
const deliveryPersonsCollection = "67c96b630024ab1bf027";
const paymentsCollection = "67cd39f90020db666b4f";
const favoritesCollection = "67ea605a001d045c96fc";

// storage
const itemsBucketId = '67dd058f002e7a062527';

// topics
const notifcationProviderId = "67e2a18f0022e80e9f47";
const notifcationsTopic = "67cd427b0039b72f15f7";

//paths
const sendMsgPath = "/send-push";

// create a function to create image url from image id
String getImageUrl(String imageId) {
  return "https://cloud.appwrite.io/v1/storage/buckets/$itemsBucketId/files/$imageId/view?project=$projectId";
}