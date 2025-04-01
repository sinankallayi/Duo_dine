import 'package:uuid/uuid.dart';

class Payment {
  static const Uuid _uuid = Uuid();

  String id;
  String transactionId;
  String status;
  String userId;
  String userName;
  String restaurantId;
  String restaurantName;
  double amount;

  Payment({
    required this.id,
    required this.status,
    required this.userId,
    this.userName = 'Unknown User',
    required this.restaurantId,
    required this.restaurantName,
    required this.amount,
  }) : transactionId =
            _uuid.v4().substring(0, 8); // Always generate a new transaction ID

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['\$id'] ?? '',
      status: json['status'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      restaurantId: json['restaurant'] is String
          ? json['restaurant']
          : (json['restaurant']?['\$id'] ?? ''),
      restaurantName:
          json['restaurant'] is Map ? (json['restaurant']?['name'] ?? '') : '',
      amount: (json['amount'] is int)
          ? (json['amount'] as int).toDouble()
          : (json['amount'] ?? 0.0),
    );
  }
}
