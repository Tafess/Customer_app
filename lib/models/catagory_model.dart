import 'dart:convert';

CategoryModel categoryModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  String image;
  String id;
  String name;
  // String price;
  // String description;
  // String status;
  // bool isFavorite;

  CategoryModel({
    required this.image,
    required this.id,
    required this.name,
    // required this.price,
    // required this.description,
    // required this.status,
    // required this.isFavorite,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        image: json['image'],
        id: json['id'],
        name: json['name'],
        // price: json['price'],
        // description: json['description'],
        // status: json['status'],
        // isFavorite: false,
      );
  Map<String, dynamic> toJson() => {
        'image': image,
        'id': id,
        'name': name,
        // 'price': price,
        // 'description': description,
        // 'status': status,
        // 'isFavorite': false,
      };
}
