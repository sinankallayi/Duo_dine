class Payment {
  String id;
  String status;
  String userId;
  String userName; // Keep userName separate
  String restaurantId;
  String restaurantName;
  double amount;

  Payment({
    required this.id,
    required this.status,
    required this.userId,
    this.userName = 'Unknown User', // Default if name isn't found
    required this.restaurantId,
    required this.restaurantName,
    required this.amount,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['\$id'] ?? '',
      status: json['status'] ?? '',
      userId: json['users'] is String
          ? json['users'] // If it's a string, use it directly
          : (json['users']?['\$id'] ?? ''), // If it's a map, extract the ID
      restaurantId: json['restaurant'] is String
          ? json['restaurant']
          : (json['restaurant']?['\$id'] ?? ''), // Extract ID from map
      restaurantName:
          json['restaurant'] is Map ? (json['restaurant']?['name'] ?? '') : '',
      amount: (json['amount'] is int)
          ? (json['amount'] as int).toDouble()
          : (json['amount'] ?? 0.0),
    );
  }
}
