// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:buyers/constants/custom_routes.dart';
import 'package:buyers/constants/custom_snackbar.dart';
import 'package:buyers/constants/custome_button.dart';
import 'package:buyers/controllers/firebase_firestore_helper.dart';
import 'package:buyers/models/product_model.dart';
import 'package:buyers/providers/app_provider.dart';
import 'package:buyers/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
// ...

class FinishedScreen extends StatefulWidget {
  final ProductModel? productModel;

  const FinishedScreen({required this.productModel, Key? key})
      : super(key: key);

  @override
  State<FinishedScreen> createState() => _FinishedScreenState();
}

class _FinishedScreenState extends State<FinishedScreen> {
  late AppProvider appProvider;

  @override
  Widget build(BuildContext context) {
    appProvider = Provider.of<AppProvider>(context);

    final store = GetStorage();
    String address = store.read('address');

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Finalize your order before closing this page',
            ),
            CustomButton(
              title: 'Finish',
              onPressed: () async {
                try {
                  appProvider.clearBuyProduct();

                  // if (widget.productModel != null ) {
                  //   appProvider.addBuyProduct(widget.productModel!);

                  bool value = await FirebaseFirestoreHelper.instance
                      .uploadOrders(
                          appProvider.getCartProductList, context, 'payed');

                  if (value) {
                    Future.delayed(const Duration(seconds: 1), () {
                      Routes.instance.push(
                          widget: FinishedScreen(
                            productModel: ProductModel(),
                          ),
                          context: context);
                      appProvider.clearBuyProduct();
                      appProvider.clearCart();
                    });
                    customSnackbar(context: context, message: 'Succesfull .');
                    Routes.instance.push(widget: Home(), context: context);
                    // }
                  } else {
                    customSnackbar(
                        context: context, message: 'Product details are null.');
                  }
                } catch (e) {
                  customSnackbar(context: context, message: e.toString());
                  print(e.toString());
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
