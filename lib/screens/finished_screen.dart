import 'package:buyers/constants/custom_routes.dart';
import 'package:buyers/constants/custom_snackbar.dart';
import 'package:buyers/constants/custome_button.dart';
import 'package:buyers/controllers/firebase_firestore_helper.dart';
import 'package:buyers/models/product_model.dart';
import 'package:buyers/providers/app_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

class FinishedScreen extends StatefulWidget {
  const FinishedScreen({super.key});

  @override
  State<FinishedScreen> createState() => _FinishedScreenState();
}

class _FinishedScreenState extends State<FinishedScreen> {
  late AppProvider appProvider;
  late final ProductModel? productModel;
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
              address,
            ),
            CustomButton(
              title: 'Finish',
              onPressed: () async {
                try {
                  appProvider.clearBuyProduct();
                  appProvider.addBuyProduct(productModel!);

                  bool value = await FirebaseFirestoreHelper.instance
                      .uploadOrders(
                          appProvider.getBuyproductList, context, 'payed');

                  if (value) {
                    Future.delayed(const Duration(seconds: 1), () {
                      Routes.instance.push(
                          widget: const FinishedScreen(), context: context);
                      appProvider.clearBuyProduct();
                      appProvider.clearCart();
                    });
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
