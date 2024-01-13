// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:buyers/constants/constants.dart';
import 'package:buyers/models/catagory_model.dart';
import 'package:buyers/models/order_model.dart';
import 'package:buyers/models/product_model.dart';
import 'package:buyers/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

class FirebaseFirestoreHelper {
  static FirebaseFirestoreHelper instance = FirebaseFirestoreHelper();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final store = GetStorage();
//---------------------------get user information-------------------------------------
  Future<UserModel?> getUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userId = user.uid;

      CollectionReference customersCollection =
          FirebaseFirestore.instance.collection('customers');

      DocumentSnapshot userSnapshot =
          await customersCollection.doc(userId).get();

      if (userSnapshot.exists) {
        return UserModel.fromJson(userSnapshot.data() as Map<String, dynamic>);
      } else {
        return UserModel(
          id: userId,
          name: 'Create your account',
          email: 'default@email.com',
          phoneNumber: '+z ,000 000 000',
        );
      }
    }

    return null; // Return null if user is null
  }

//----------------------get categories------------------------------------------
  Future<List<CategoryModel>> getCategories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collection('categories').get();
      List<CategoryModel> categoriesList = querySnapshot.docs
          .map((e) => CategoryModel.fromJson(e.data()))
          .toList();
      return categoriesList; // Return the mapped categoriesList
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }
  //----------------------------------------------------------------------------

  //---------------------get products-------------------------------------------

  Future<List<ProductModel>> getProducts() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collectionGroup('products').get();

      List<ProductModel> productModelList = querySnapshot.docs
          .map((e) => ProductModel.fromJson(e.data()))
          .where((product) =>
              product.quantity >
              0) // Filter products with quantity greater than 0
          .toList();

      return productModelList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

//--------------------------get products by category--------------------------------------
  Future<List<ProductModel>> getCategoryViewProduct(String id) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection('categories')
              .doc(id)
              .collection('products')
              .get();
      List<ProductModel> productModelList = querySnapshot.docs
          .map((e) => ProductModel.fromJson(e.data()))
          .where((product) => product.quantity > 0)
          .toList();
      return productModelList; // Return the mapped productModelList
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

//-------------------------user information---------------------------------------
  Future<UserModel> getUserInformation() async {
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await _firebaseFirestore
            .collection('customers')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
    return UserModel.fromJson(querySnapshot.data()!);
  }
//----------------------------------------------------------------------------

  Future<bool> uploadOrders(
      List<ProductModel> list, BuildContext context, String payment) async {
    String address = store.read('address');
    String latitude = store.read('latitude');
    String longitude = store.read('longitude');
    String phoneNumber = store.read('phoneNumber');
    DateTime orderDate = DateTime.now();
    int calculateTotalQuantity(List<ProductModel> products) {
      int totalQuantity = 0;

      for (ProductModel product in products) {
        totalQuantity += product.quantity ?? 0;
      }

      return totalQuantity;
    }

    int totalOrderedQuantity = calculateTotalQuantity(list);

    try {
      ShowLoderDialog(context);
      double totalPrice = 0.0;
      for (var element in list) {
        totalPrice += element.price * element.quantity;
      }
      DocumentReference documentReference = _firebaseFirestore
          .collection('orderssssss')
          .doc(FirebaseAuth.instance.currentUser!.uid);

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collectionGroup('products').get();
      String productId = querySnapshot.docs.first.id;

      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firebaseFirestore.collection('products').doc(productId).get();
      String sellerId = snapshot['sellerId'];
      String uid = FirebaseAuth.instance.currentUser!.uid;
      documentReference.set({
        'products': list.map((e) => e.toJson()),
        'status': 'pending',
        'totalprice': totalPrice,
        'payment': payment,
        'userId': uid,
        'orderId': documentReference.id,
        'sellerId': sellerId,
        'address': address,
        'phoneNumber': phoneNumber,
        'latitude': latitude,
        'longitude': longitude,
        'orderDate': orderDate,
        'deliveryId': '',
        'deliveryName': '',
        'deliveryPhone': '',
      }).then((value) {
        _updateProductInCollection('products', productId, totalOrderedQuantity);
        //  _updateProductInCollectionGroup('products', productId, totalOrderedQuantity);
      });
      showMessage('Ordered Successfully');

      return true;
    } catch (e) {
      showMessage(e.toString());
      Navigator.of(context, rootNavigator: true).pop();
      return false;
    }
  }

//---------------------upload orders -------------------------------------------

  // Future<bool> uploadOrderedProductFirebase(
  //     List<ProductModel> list, BuildContext context, String payment) async {
  //   String address = store.read('address');
  //   String latitude = store.read('latitude');
  //   String longitude = store.read('longitude');
  //   DateTime orderDate = DateTime.now();
  //   try {
  //     ShowLoderDialog(context);
  //     double totalPrice = 0.0;
  //     for (var element in list) {
  //       totalPrice += element.price * element.quantity;
  //     }
  //     DocumentReference documentReference = _firebaseFirestore
  //         .collection('userOrders')
  //         .doc(FirebaseAuth.instance.currentUser!.uid)
  //         .collection('orders')
  //         .doc();

  //     DocumentReference admin =
  //         _firebaseFirestore.collection('orders').doc(documentReference.id);

  //     QuerySnapshot<Map<String, dynamic>> querySnapshot =
  //         await _firebaseFirestore.collectionGroup('products').get();
  //     String productId = querySnapshot.docs.first.id;

  //     DocumentSnapshot<Map<String, dynamic>> snapshot = await _firebaseFirestore
  //         .collection('adminProducts')
  //         .doc(productId)
  //         .get();
  //     String sellerId = snapshot['sellerId'];
  //     String uid = FirebaseAuth.instance.currentUser!.uid;
  //     admin.set({
  //       'products': list.map((e) => e.toJson()),
  //       'status': 'pending',
  //       'totalprice': totalPrice,
  //       'payment': payment,
  //       'userId': uid,
  //       'orderId': admin.id,
  //       'sellerId': sellerId,
  //       'address': address,
  //       'latitude': double.parse(latitude),
  //       'longitude': double.parse(longitude),
  //       'orderDate': orderDate,
  //       'deliveryId': '',
  //       'deliveryName': '',
  //       'deliveryPhone': '',
  //     });

  //     documentReference.set({
  //       'products': list.map((e) => e.toJson()),
  //       'status': 'pending',
  //       'totalprice': totalPrice,
  //       'payment': payment,
  //       'userId': uid,
  //       'orderId': documentReference.id,
  //       'sellerId': sellerId,
  //       'address': address,
  //       'latitude': latitude,
  //       'longitude': longitude,
  //       'orderDate': orderDate,
  //       'deliveryId': '',
  //       'deliveryName': '',
  //       'deliveryPhone': '',
  //     });
  //     showMessage('Ordered Successfully');
  //     Navigator.of(context, rootNavigator: true).pop();

  //     return true;
  //   } catch (e) {
  //     showMessage(e.toString());
  //     Navigator.of(context, rootNavigator: true).pop();
  //     return false;
  //   }
  // }

  //------------------------get user orders----------------------------------------

  Future<List<OrderModel>> getOrders() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userId = user.uid;

      try {
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await _firebaseFirestore
                .collection('orders')
                .where('userId', isEqualTo: userId)
                .get();

        List<OrderModel> orderList = querySnapshot.docs
            .map((element) => OrderModel.fromJson(element.data()))
            .toList();

        return orderList;
      } catch (error) {
        showMessage(error.toString());
        print(error.toString());
        return [];
      }
    }

    return []; // Return an empty list if user is null
  }

  // Future<List<OrderModel>> getUserOrder() async {
  //   try {
  //     QuerySnapshot<Map<String, dynamic>> querySnapshot =
  //         await _firebaseFirestore
  //             .collection('userOrders')
  //             .doc(FirebaseAuth.instance.currentUser!.uid)
  //             .collection('orders')
  //             .get();

  //     List<OrderModel> orderList = querySnapshot.docs
  //         .map((element) => OrderModel.fromJson(element.data()))
  //         .toList();

  //     return orderList;
  //   } catch (error) {
  //     showMessage(error.toString());
  //     print(error.toString());

  //     return [];
  //   }
  // }

  // //----------------------------------------------------------------

  void updateTokenFromFirebase() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await _firebaseFirestore
          .collection('sellers')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      // .update({'notificationToken': token});
    }
  }

//-----------------------update orders-----------------------------------------

  // Future<void> updateOrder(OrderModel orderModel, String status) async {
  //   await _firebaseFirestore
  //       .collection('userOrders')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .collection('orders')
  //       .doc(orderModel.orderId)
  //       .update({'status': status});

  //   await _firebaseFirestore
  //       .collection('orders')
  //       .doc(orderModel.orderId)
  //       .update({'status': status});
  // }

//----------------------------------------------------------------
  Future<String> generateQRCode(String orderId) async {
    String qrCodeData = orderId;

    return qrCodeData;
  }

  //-----------------------------------------------------------------------------------

  Future<void> updateProduct(
      String collectionName, String productId, int quantity) async {
    try {
      if (collectionName == 'products') {
        await _updateProductInCollection(collectionName, productId, quantity);
      } else {
        await _updateProductInCollectionGroup(
            collectionName, productId, quantity);
      }

      print('Product quantity updated successfully.');
    } catch (e) {
      print('Error updating product: $e');
      showMessage('Error updating product: $e');
    }
  }

  Future<void> _updateProductInCollection(
      String collectionName, String productId, int quantity) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection(collectionName)
              .where('productId', isEqualTo: productId)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot<Map<String, dynamic>> document
            in querySnapshot.docs) {
          DocumentReference productRef =
              _firebaseFirestore.doc(document.reference.path);

          Map<String, dynamic> productInfo = document.data();
          int oldQuantity = productInfo['quantity'] ?? 0;

          int newQuantity = oldQuantity - quantity;
          if (newQuantity >= 0) {
            await productRef.update({'quantity': newQuantity});
          } else {
            showMessage(
                'Some error occurred while updating product quantity in $collectionName collection');
          }
        }
      } else {
        print('Product not found in $collectionName collection');
      }
    } catch (e) {
      print('Error updating product in $collectionName collection: $e');
      showMessage('Error updating product in $collectionName collection: $e');
    }
  }

  Future<void> _updateProductInCollectionGroup(
      String collectionGroupName, String productId, int quantity) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collectionGroup(collectionGroupName)
              .where('productId', isEqualTo: productId)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot<Map<String, dynamic>> document
            in querySnapshot.docs) {
          DocumentReference productRef =
              _firebaseFirestore.doc(document.reference.path);

          Map<String, dynamic> productInfo = document.data();
          int oldQuantity = productInfo['quantity'] ?? 0;

          int newQuantity = oldQuantity - quantity;
          if (newQuantity >= 0) {
            await productRef.update({'quantity': newQuantity});
          } else {
            showMessage(
                'Some error occurred while updating product quantity in $collectionGroupName collection group');
          }
        }
      } else {
        print('Product not found in $collectionGroupName collection group');
      }
    } catch (e) {
      print(
          'Error updating product in $collectionGroupName collection group: $e');
      showMessage(
          'Error updating product in $collectionGroupName collection group: $e');
    }
  }
}
