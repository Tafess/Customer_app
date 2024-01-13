// ignore_for_file: prefer_const_constructors

import 'package:buyers/constants/constants.dart';
import 'package:buyers/constants/custom_snackbar.dart';
import 'package:buyers/constants/custom_text.dart';
import 'package:buyers/constants/custome_button.dart';
import 'package:buyers/constants/custom_routes.dart';
import 'package:buyers/controllers/firebase_firestore_helper.dart';
import 'package:buyers/providers/app_provider.dart';
import 'package:buyers/screens/custom_drawer.dart';
import 'package:buyers/screens/google_map.dart';
import 'package:buyers/screens/login.dart';
import 'package:buyers/widgets/single_cart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final FirebaseFirestoreHelper _firestoreHelper = FirebaseFirestoreHelper();
  final userId = FirebaseAuth.instance.currentUser;
  int quantity = 1;
  final store = GetStorage();
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('cart'.tr),
        actions: const [
          Icon(Icons.shopping_bag),
        ],
      ),
      drawer: CustomDrawer(),
      bottomNavigationBar: appProvider.getCartProductList.isNotEmpty
          ? Container(
              height: 150,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'total'.tr,
                            style: TextStyle(
                                fontSize: 20,
                                // color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Text(
                                '  ${appProvider.totalPrice().toString()}  ',
                                style: const TextStyle(
                                    fontSize: 20,
                                    //  color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                              text(title: 'etb'.tr),
                            ],
                          ),
                          const SizedBox(width: 50),
                          Expanded(
                            child: CustomButton(
                              title: 'continue'.tr,
                              onPressed: () {
                                if (userId != null) {
                                  store.write('totalPrice',
                                      appProvider.totalPrice().toString());
                                  store.write('quantity', quantity);

                                  
                                  Routes.instance.push(
                                      widget: MapScreen(), context: context);
                                  // appProvider.clearBuyProduct();
                                  // appProvider.addBuyProductCartList();
                                  // // appProvider.clearCart();
                                  // if (appProvider.getBuyproductList.isEmpty) {
                                  //   showMessage('Cart is empty');
                                  // } else {

                                  // }
                                } else {
                                  customSnackbar(
                                      context: context,
                                      duration: Duration(seconds: 5),
                                      message:
                                          'Please  sign in befor procede to next step',
                                      backgroundColor: Colors.red,
                                      messageColor: Colors.white,
                                      closLabel: 'OK',
                                      closTextColor: Colors.white);
                                  Routes.instance
                                      .push(widget: Login(), context: context);
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SizedBox.fromSize(),
      body: appProvider.getCartProductList.isEmpty
          ? Center(
              child: Text('emptyCart'.tr),
            )
          : ListView.builder(
              itemCount: appProvider.getCartProductList.length,
              itemBuilder: (ctx, index) {
                return SIngleCartItem(
                    singleProduct: appProvider.getCartProductList[index]);
              },
            ),
    );
  }
}
