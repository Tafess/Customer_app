// chapa.dart

// ignore_for_file: unused_local_variable, prefer_const_constructors, prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'dart:convert';
import 'package:buyers/constants/custom_routes.dart';
import 'package:buyers/constants/custom_snackbar.dart';
import 'package:buyers/constants/custome_button.dart';
import 'package:buyers/controllers/firebase_firestore_helper.dart';
import 'package:buyers/models/product_model.dart';
import 'package:buyers/providers/app_provider.dart';
import 'package:buyers/screens/cart_screen.dart';
import 'package:buyers/screens/finished_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:chapa_unofficial/chapa_unofficial.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChapaPayment extends StatefulWidget {
  const ChapaPayment({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<ChapaPayment> createState() => _ChapaPaymentState();
}

class _ChapaPaymentState extends State<ChapaPayment> {
  FirebaseFirestoreHelper _firestoreHelper = FirebaseFirestoreHelper();

  final store = GetStorage();

  Future<void> verify() async {
    Map<String, dynamic> verificationResult =
        await Chapa.getInstance.verifyPayment(
      txRef: 'GENERATED_TRANSACTION_REFERENCE',
    );
  }

  Future<void> pay() async {
    String totalPrice = store.read('totalPrice');
    try {
      String txRef = TxRefRandomGenerator.generate(prefix: 'Pharmabet');

      String storedTxRef = TxRefRandomGenerator.gettxRef;

      await Chapa.getInstance.startPayment(
        context: context,
        onInAppPaymentSuccess: (successMsg) async {
          customSnackbar(context: context, message: successMsg);
          Routes.instance.push(widget: FinishedScreen(), context: context);
        },
        onInAppPaymentError: (errorMsg) {
          customSnackbar(context: context, message: errorMsg);
          Routes.instance.push(widget: CartScreen(), context: context);
          if (kDebugMode) {
            print('errorMsg: ' + errorMsg);
          }
        },
        amount: totalPrice,
        currency: 'ETB',
        txRef: storedTxRef,
      );
    } on ChapaException catch (e) {
      if (e is AuthException) {
        print('authException');
      } else if (e is InitializationException) {
        print('initializationException');
      } else if (e is NetworkException) {
        print('networkException');
      } else if (e is ServerException) {
        print('serverException');
      } else {
        print('unknown error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Move the initialization of appProvider inside the build method

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chapa payment"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Pay to Belkis',
            ),
            Expanded(
              child: Row(
                children: [
                  CustomButton(
                    onPressed: () async {
                      await pay();
                    },
                    title: 'Pay',
                    color: Colors.green.shade200,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: Row(
                children: [
                  CustomButton(
                    onPressed: () async {
                      await verify();
                    },
                    title: 'Verify',
                    color: Colors.blue.shade200,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
