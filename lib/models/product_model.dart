import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  String image;
  String id;
  String name;
  double price;
  String? description;
  String status;
  bool isFavorite;
  int? quantity;
  String categoryId;
  ProductModel({
    required this.image,
    required this.id,
    required this.name,
    required this.price,
    this.description,
    required this.status,
    required this.isFavorite,
    this.quantity,
    required this.categoryId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        image: json["image"],
        id: json["id"],
        name: json["name"],
        price: (json["price"] as num).toDouble(),
        description: json["description"],
        status: json["status"],
        isFavorite: false,
        quantity: json["quantity"],
        categoryId: json["categoryId"],
      );
  Map<String, dynamic> toJson() => {
        "image": image,
        "id": id,
        "name": name,
        "price": price,
        "description": description,
        "status": status,
        "isFavorite": isFavorite,
        "quantity": quantity,
        "categoryId": categoryId,
      };

  ProductModel copyWith({
    int? quantity,
  }) =>
      ProductModel(
        id: id,
        name: name,
        description: description,
        image: image,
        isFavorite: isFavorite,
        quantity: quantity ?? this.quantity,
        price: price,
        status: status,
        categoryId: categoryId,
      );
}
