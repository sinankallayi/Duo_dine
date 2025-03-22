import 'package:appwrite/models.dart';
import 'package:foodly_ui/models/restaurant_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/state_manager.dart';

User? user;
Position? location;
String place = "Location Not Found";
bool isCustomer = false;
Rxn<Restaurant> restaurant = Rxn<Restaurant>();
