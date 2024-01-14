import 'dart:convert';

String productModelToJson(ProductModel data) => json.encode(data.toJson());

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

class ProductModel {
  String? categoryId;
  String? description;
  String? image;
  String? name;
  double? price;
  double? discount;
  int? quantity;
  double? size;
  String? measurement;
  String? status;
  bool? isFavorite;
  bool? disabled;
  String? productId;
  String? sellerId;

  ProductModel({
     this.categoryId,
     this.description,
     this.image,
     this.name,
     this.price,
     this.discount,
     this.quantity,
     this.size,
     this.measurement,
     this.status,
     this.isFavorite,
     this.disabled,
     this.productId,
     this.sellerId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      categoryId: json['categoryId'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      size: (json['size'] as num?)?.toDouble() ?? 0.0,
      measurement: json['measurement'] ?? '',
      status: json['status'] ?? '',
      isFavorite: false,
      disabled: json['disabled'] ?? false,
      productId: json['productId'] ?? '',
      sellerId: json['sellerId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'description': description,
   
      'image': image,
      'name': name,
      'price': price,
      'discount': discount,
      'quantity': quantity,
      'size': size,
      'measurement': measurement,
      'status': status,
      'isFavorite': false,
      'disabled': false,
      'productId': productId,
      'sellerId': sellerId,
    };
  }

  ProductModel copyWith({
    String? categoryId,
    String? description,
    String? id,
    String? image,
    String? name,
    double? price,
    double? discount,
    int? quantity,
    double? size,
    String? measurement,
    String? status,
    String? productId,
    String? sellerId,
  }) {
    return ProductModel(
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
     
      image: image ?? this.image,
      name: name ?? this.name,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
      measurement: measurement ?? this.measurement,
      status: status ?? this.status,
      isFavorite: false,
      disabled: false,
      productId: productId ?? this.productId,
      sellerId: sellerId ?? this.sellerId,
    );
  }
}
