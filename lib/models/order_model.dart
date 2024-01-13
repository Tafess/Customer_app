import 'package:buyers/models/product_model.dart';

class OrderModel {
  String payment;
  String status;
  List<ProductModel> products;
  double totalprice;
  String orderId;
  String userId;
  String sellerId;
  String? address;
  String? phoneNumber;
  double? latitude;
  double? longitude;
  DateTime orderDate;
  String? deliveryId;
  String? deliveryName;
  String? deliveryPhone;

  OrderModel({
    required this.totalprice,
    required this.orderId,
    required this.payment,
    required this.products,
    required this.status,
    required this.userId,
    required this.sellerId,
    this.address,
    this.phoneNumber,
    this.latitude,
    this.longitude,
    required this.orderDate,
    this.deliveryId,
    this.deliveryName,
    this.deliveryPhone,
  });
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    List<dynamic>? productMap = json['products'];
    return OrderModel(
      orderId: json['orderId'] != null ? json['orderId'] as String : "",
      products:
          (productMap ?? []).map((e) => ProductModel.fromJson(e)).toList(),
      totalprice: (json['totalprice'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] != null ? json['status'] as String : "",
      payment: json['payment'] != null ? json['payment'] as String : "",
      userId: json['userId'] != null ? json['userId'] as String : "",
      sellerId: json['sellerId'] != null ? json['sellerId'] as String : "",
      address: json['address'] != null ? json['address'] as String : "",
      phoneNumber:
          json['phoneNumber'] != null ? json['phoneNumber'] as String : "",
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      orderDate: json['orderDate'] != null
          ? DateTime.parse(json['orderDate'])
          : DateTime.now(),
      deliveryId:
          json['deliveryId'] != null ? json['deliveryId'] as String : "",
      deliveryName:
          json['deliveryName'] != null ? json['deliveryName'] as String : "",
      deliveryPhone:
          json['deliveryPhone'] != null ? json['deliveryPhone'] as String : "",
    );
  }
}
