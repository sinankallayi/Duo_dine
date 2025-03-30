import '../enums/delivery_status.dart';

class DeliveryPersonModel {
  String phone = '';
  String location = '';
  String name = '';
  String $id = '';
  final DeliveryStatus deliveryStatus;

  DeliveryPersonModel({
    required this.phone,
    required this.location,
    required this.name,
    required this.$id,
    required this.deliveryStatus,
  });

  factory DeliveryPersonModel.fromJson(Map<String, dynamic> json) {
    return DeliveryPersonModel(
      phone: json['phone'],
      location: json['location'],
      name: json['name'],
      $id: json['\$id'],
      deliveryStatus: DeliveryStatusExtension.fromString(json['deliveryStatus']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'location': location,
      'deliveryStatus': deliveryStatus.value,
    };
  }
}
