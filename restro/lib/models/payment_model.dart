import 'package:foodly_ui/models/restaurant_model.dart';

class Payment {
  String id;
  String status;
  String userId;
  String userName;
  Restaurant restaurant;
  double amount;

  Payment({
    required this.id,
    required this.status,
    required this.userId,
    required this.userName,
    required this.restaurant,
    required this.amount,
  });

  // Convert JSON to Payment object
  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['\$id'] ?? '', // Ensure ID is retrieved correctly
      status: json['status'] ?? '',
      userId: json['userId'] ?? "", // Handle nested object
      userName: json['userName'] ?? "", // Handle nested object
      restaurant:
          Restaurant.fromJson(json['restaurant']), // Handle nested object
      amount: (json['amount'] is int)
          ? (json['amount'] as int).toDouble()
          : (json['amount'] ?? 0.0),
    );
  }

  // Convert Payment object to JSON
  // Map<String, dynamic> toJson() {
  //   return {
  //     'status': status,
  //     'users': userId,
  //     'users': userId,
  //     'restaurant': restaurant,
  //     'amount': amount,
  //   };
  // }
}
