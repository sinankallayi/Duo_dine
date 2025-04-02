import 'package:foodly_ui/models/enums/order_status.dart';

class OrderTimeline {
  DateTime? createdDate;
  String itemId;
  OrderStatus status;
  String description;
  bool isCompleted = false;

  OrderTimeline({
    required this.createdDate,
    required this.itemId,
    required this.status,
    required this.description,
  }){
    isCompleted = createdDate != null;
  }

  //from json
  factory OrderTimeline.fromJson(Map<String, dynamic> json) {
    return OrderTimeline(
      createdDate: json['\$createdAt'] !=null ? DateTime.parse(json['\$createdAt']).toLocal() : null,
      status: OrderStatusExtension.fromString(json['status']),
      itemId: json['itemId'],
      description: json['description'] ?? "",
    );
  }
}
