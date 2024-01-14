import 'package:buyers/constants/constants.dart';
import 'package:buyers/constants/custom_routes.dart';
import 'package:buyers/constants/custom_snackbar.dart';
import 'package:buyers/constants/custom_text.dart';
import 'package:buyers/constants/custome_button.dart';

import 'package:buyers/models/product_model.dart';
import 'package:buyers/providers/app_provider.dart';
import 'package:buyers/screens/cart_screen.dart';
import 'package:buyers/screens/check_out.dart';
import 'package:buyers/screens/favorite_screen.dart';
import 'package:buyers/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/utils.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel singleProduct;

  const ProductDetails({Key? key, required this.singleProduct})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final userId = FirebaseAuth.instance.currentUser;
  int quantity = 1;

  ScrollController? _scrollController;
  bool _isScrollDown = false;
  bool _showAppBar = true;

  @override
  void initState() {
    _scrollController = ScrollController();

    _scrollController!.addListener(() {
      if (_scrollController!.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!_isScrollDown) {
          setState(() {
            _isScrollDown = true;
            _showAppBar = false;
          });
        }
      }
      if (_scrollController!.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (_isScrollDown) {
          setState(() {
            _isScrollDown = false;
            _showAppBar = true;
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );

    return Scaffold(
      appBar: _showAppBar
          ? AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    Routes.instance
                        .push(widget: const CartScreen(), context: context);
                  },
                  icon: const Icon(Icons.shopping_cart),
                ),
                IconButton(
                  onPressed: () {
                    Routes.instance
                        .push(widget: const FavoriteScreen(), context: context);
                  },
                  icon: const Icon(
                    Icons.favorite,
                  ),
                ),
              ],
            )
          : null,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12.0, 12, 12, 30),
        children: [
          SizedBox(
            height: 200,
            width: double.infinity,
            child: Image.network(
              widget.singleProduct.image!,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.singleProduct.name!,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    widget.singleProduct.isFavorite =
                        !widget.singleProduct.isFavorite!;
                  });
                  if (widget.singleProduct.isFavorite!) {
                    appProvider.addToFavoriteproduct(widget.singleProduct);
                    showMessage('addedToFavorites'.tr);
                  } else {
                    appProvider.removeFavoriteproduct(widget.singleProduct);
                    showMessage('removedFromFavorites'.tr);
                  }
                },
                icon: Icon(
                  appProvider.getFavoriteProductList
                          .contains(widget.singleProduct)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          Text(
            widget.singleProduct.description!,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          text(
              title:
                  '${widget.singleProduct.size}  ${widget.singleProduct.measurement}'),
          Row(
            children: [
              text(title: 'availableItems'.tr),
              Text(
                '         ${widget.singleProduct.quantity.toString()}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              CupertinoButton(
                onPressed: () {
                  if (quantity > 1) {
                    setState(() {
                      quantity--;
                    });
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
              if (quantity < widget.singleProduct.quantity!)
                CupertinoButton(
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                  padding: EdgeInsets.zero,
                  child: CircleAvatar(
                    maxRadius: 14,
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green.shade300,
                    child: Icon(Icons.add),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 50),
          Row(
            children: [
              text(title: 'totalPrice'.tr),
              Text(
                  '  ${widget.singleProduct.discount == 0.0 ? widget.singleProduct.price! * quantity : widget.singleProduct.discount! * quantity}'),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                onPressed: () {
                  AppProvider appProvider = Provider.of(context, listen: false);

                  // Check if the product is already in the cart
                  if (appProvider.isInCart(widget.singleProduct.productId!)) {
                    showMessage('alreadyInCart'.tr);
                  } else {
                    ProductModel productModel =
                        widget.singleProduct.copyWith(quantity: quantity);
                    appProvider.addToCartproduct(productModel);
                    showMessage('addedToCart'.tr);
                  }
                },
                title: 'addToCart'.tr,
              ),
              const SizedBox(
                width: 12,
              ),
              CustomButton(
                onPressed: () {
                  if (userId != null) {
                    ProductModel productModel =
                        widget.singleProduct.copyWith(quantity: quantity);
                    //Routes.instance.push(widget: MapScreen(), context: context);
                    Routes.instance.push(
                        widget: CheckOutScreen(
                          singleProduct: productModel,
                        ),
                        context: context);
                  } else {
                    customSnackbar(
                        context: context,
                        message:
                            'Please sign in before procede to the next step',
                        backgroundColor: Colors.red);
                    Routes.instance.push(widget: Login(), context: context);
                  }
                },
                // color: Colors.green,
                title: 'buy'.tr,
              ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
