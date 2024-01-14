import 'package:buyers/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String? payment;
  String? status;
  List<ProductModel>? products;
  double? totalprice;
  String orderId;
  String? userId;
  String? sellerId;
  String? address;
  String? phoneNumber;
  double? latitude;
  double? longitude;
  DateTime? orderDate;
  String? deliveryId;
  String? deliveryName;
  String? deliveryPhone;

  OrderModel({
    this.totalprice,
    required this.orderId,
    this.payment,
    this.products,
    this.status,
    this.userId,
    this.sellerId,
    this.address,
    this.phoneNumber,
    this.latitude,
    this.longitude,
    this.orderDate,
    this.deliveryId,
    this.deliveryName,
    this.deliveryPhone,
  });
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    List<dynamic>? productMap = json['products'];
    return OrderModel(
      orderId: json['orderId'] != null ? json['orderId'] as String : "",
      products:
          List.from((productMap ?? []).map((e) => ProductModel.fromJson(e))),
      totalprice: (json['totalprice'] is String)
          ? double.tryParse(json['totalprice'] ?? "") ?? 0.0
          : (json['totalprice'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] != null ? json['status'] as String : "",
      payment: json['payment'] != null ? json['payment'] as String : "",
      userId: json['userId'] != null ? json['userId'] as String : "",
      sellerId: json['sellerId'] != null ? json['sellerId'] as String : "",
      address: json['address'] != null ? json['address'] as String : "",
      phoneNumber:
          json['phoneNumber'] != null ? json['phoneNumber'] as String : "",
      latitude: (json['latitude'] is String)
          ? double.tryParse(json['latitude'] ?? "") ?? 0.0
          : (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] is String)
          ? double.tryParse(json['longitude'] ?? "") ?? 0.0
          : (json['longitude'] as num?)?.toDouble() ?? 0.0,
      orderDate: json['orderDate'] != null
          ? (json['orderDate'] as Timestamp).toDate()
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
