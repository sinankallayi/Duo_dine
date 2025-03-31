class FavoriteModel {
  final String id;
  final String userId;
  final String itemId;

  FavoriteModel({
    required this.id,
    required this.userId,
    required this.itemId,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['\$id'],
      userId: json['userId'],
      itemId: json['itemId'],
    );
  }
}
