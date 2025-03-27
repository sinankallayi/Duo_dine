class Payment {
  String id;
  String status;
  String userId;
  String restaurantId;
  double amount;

  Payment({
    required this.id,
    required this.status,
    required this.userId,
    required this.restaurantId,
    required this.amount,
  });

  // Convert JSON to Payment object
  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['\$id'] ?? '', // Ensure ID is retrieved correctly
      status: json['status'] ?? '',
      userId: json['users'] is String
          ? json['users']
          : json['users']['\$id'] ?? '', // Handle nested object
      restaurantId: json['restaurant'] is String
          ? json['restaurant']
          : json['restaurant']['\$id'] ?? '', // Handle nested object
      amount: (json['amount'] is int)
          ? (json['amount'] as int).toDouble()
          : (json['amount'] ?? 0.0),
    );
  }

  // Convert Payment object to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'users': userId,
      'restaurant': restaurantId,
      'amount': amount,
    };
  }
}
