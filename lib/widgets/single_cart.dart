import 'dart:async';

import 'package:buyers/constants/constants.dart';
import 'package:buyers/constants/custom_snackbar.dart';
import 'package:buyers/constants/custom_text.dart';
import 'package:buyers/models/product_model.dart';
import 'package:buyers/providers/app_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:provider/provider.dart';

class SIngleCartItem extends StatefulWidget {
  final ProductModel singleProduct;
  const SIngleCartItem({Key? key, required this.singleProduct})
      : super(key: key);

  @override
  State<SIngleCartItem> createState() => _SIngleCartItemState();
}

class _SIngleCartItemState extends State<SIngleCartItem> {
  int quantity = 1;
  bool hideIncrementButton = false;
  int quantityInFirebase = 0;

  @override
  void initState() {
    super.initState();
    // Fetch product information from Firebase when the widget is initialized
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      getProductInfo(widget.singleProduct.productId!);
    });
  }

  final _productController = StreamController<Map<String, dynamic>>.broadcast();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Stream<Map<String, dynamic>> get productStream => _productController.stream;

  Future<void> getProductInfo(String productId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collectionGroup('products')
              .where('productId', isEqualTo: widget.singleProduct.productId)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> productInfo = querySnapshot.docs.first.data();
        _productController.add(productInfo);

        int firebaseQuantity = productInfo['quantity'] ?? 0;
        setState(() {
          quantityInFirebase = firebaseQuantity;
        });
      } else {
        showMessage('Product not found');
      }
    } catch (e) {
      print(e.toString());
      showMessage(e.toString());
    }
  }

  void dispose() {
    _productController.close();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.background,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 140,
                    color: Theme.of(context).colorScheme.primary,
                    child: Image.network(widget.singleProduct.image!),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 140,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FittedBox(
                                    child: Text(
                                      widget.singleProduct.name!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      CupertinoButton(
                                        onPressed: () {
                                          if (quantity > 1) {
                                            setState(() {
                                              quantity--;
                                            });
                                            appProvider.updateQuantity(
                                                widget.singleProduct, quantity);
                                          }
                                        },
                                        padding: EdgeInsets.zero,
                                        child: const CircleAvatar(
                                          maxRadius: 14,
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.red,
                                          child: Icon(Icons.remove),
                                        ),
                                      ),
                                      Text(
                                        quantity.toString(),
                                        style: const TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (quantity < quantityInFirebase)
                                        CupertinoButton(
                                          onPressed: () {
                                            if (quantity ==
                                                quantityInFirebase - 1) {
                                              customSnackbar(
                                                  context: context,
                                                  message:
                                                      'Only $quantityInFirebase available items found in store');
                                            }
                                            setState(() {
                                              quantity++;
                                            });
                                            appProvider.updateQuantity(
                                                widget.singleProduct, quantity);
                                          },
                                          padding: EdgeInsets.zero,
                                          child:  CircleAvatar(
                                            maxRadius: 14,
                                            foregroundColor: Colors.white,
                                            backgroundColor: Colors.green.shade300,
                                            child: Icon(Icons.add),
                                          ),
                                        ),
                                    ],
                                  ),
                                  CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      if (!appProvider.getFavoriteProductList
                                          .contains(widget.singleProduct)) {
                                        appProvider.addToFavoriteproduct(
                                            widget.singleProduct);
                                        showMessage('addedToFavorites'.tr);
                                      } else {
                                        appProvider.removeFavoriteproduct(
                                            widget.singleProduct);
                                        showMessage('removedFromFavorites'.tr);
                                      }
                                    },
                                    child: Text(
                                      appProvider.getFavoriteProductList
                                              .contains(widget.singleProduct)
                                          ? 'removeWishList'.tr
                                          : 'addToWishList'.tr,
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  FittedBox(
                                    child: Row(
                                      children: [
                                        text(title: 'price'.tr),
                                        Text(
                                          '    ${(widget.singleProduct.discount == 0.0 ? widget.singleProduct.price : widget.singleProduct.discount)!.toDouble()} ',
                                        ),
                                        text(title: 'etb'.tr),
                                      ],
                                    ),
                                  ),
                                  FittedBox(
                                    child: Row(
                                      children: [
                                        text(title: 'total'.tr),
                                        Text(
                                          '  ${widget.singleProduct.discount == 0.0 ? widget.singleProduct.price! * quantity : widget.singleProduct.discount !* quantity} ',
                                        ),
                                        text(title: 'etb'.tr),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          CupertinoButton(
                            child: const CircleAvatar(
                              backgroundColor: Colors.white,
                              maxRadius: 14,
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                            onPressed: () {
                              appProvider
                                  .removeCartproduct(widget.singleProduct);
                              showMessage('removedFromCart'.tr);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}


