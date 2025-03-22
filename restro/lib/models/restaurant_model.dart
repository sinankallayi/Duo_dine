class Restaurant {
  String name;
  String address;
  String location;
  String tags;
  String description;
  bool approved;
  String phone;
  double? rating;
  String id;
  String? image;
  DateTime createdAt;
  DateTime updatedAt;

  Restaurant({
    required this.name,
    required this.address,
    required this.location,
    required this.tags,
    required this.description,
    required this.approved,
    required this.phone,
    this.rating,
    this.image,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      name: json['name'],
      address: json['address'],
      location: json['location'],
      tags: json['tags'],
      description: json['description'],
      approved: json['approved'],
      phone: json['phone'],
      image: json['image'],
      rating: json['rating'] != null ? json['rating'].toDouble() : null,
      id: json['\$id'],
      createdAt: DateTime.parse(json['\$createdAt']),
      updatedAt: DateTime.parse(json['\$updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'location': location,
      'tags': tags,
      'description': description,
      'approved': approved,
      'phone': phone,
      'rating': rating,
      '\$id': id,
      '\$createdAt': createdAt.toIso8601String(),
      '\$updatedAt': updatedAt.toIso8601String(),
    };
  }
}
