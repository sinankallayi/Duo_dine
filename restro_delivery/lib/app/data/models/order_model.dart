import 'restaurant_model.dart';

class OrderModel {
  String $id;
  List<Restaurant> restaurant;
  DateTime createdDate;
  double total_price;
  String status;
  String? user;
  String? complaints;

  OrderModel({
    required this.$id,
    required this.restaurant,
    required this.total_price,
    required this.createdDate,
    required this.status,
    required this.user,
    required this.complaints,
  });

  //from json
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      $id: json['\$id'],
      createdDate: DateTime.parse(json['\$createdAt']),
      restaurant: List<Restaurant>.from(json['restaurant'].map((x) => Restaurant.fromJson(x))),
      total_price: double.parse(json['total_price'].toString()),
      status: json['status'],
      user: json['users'].toString(),
      complaints: json['complaints'],
    );
  }
}
