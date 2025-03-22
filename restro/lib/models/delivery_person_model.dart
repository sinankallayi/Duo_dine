class DeliveryPersonModel {
  bool available = true;
  String phone = '';
  String location = '';
  String name = '';
  String $id = '';

  DeliveryPersonModel({
    required this.available,
    required this.phone,
    required this.location,
    required this.name,
    required this.$id,
  });

  factory DeliveryPersonModel.fromJson(Map<String, dynamic> json) {
    return DeliveryPersonModel(
      available: json['available'],
      phone: json['phone'],
      location: json['location'],
      name: json['name'],
      $id: json['\$id'],
    );
  }
}
