// chapa.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:chapa_unofficial/chapa_unofficial.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ChapaPayment extends StatefulWidget {
  const ChapaPayment({super.key, required this.title});

  final String title;

  @override
  State<ChapaPayment> createState() => _ChapaPaymentState();
}

class _ChapaPaymentState extends State<ChapaPayment> {
  // final int _counter = 0;

  Future<void> verify() async {
    Map<String, dynamic> verificationResult =
        await Chapa.getInstance.verifyPayment(
      txRef: 'GENERATED_TRANSACTION_REFERENCE',
    );
  }

  Future<void> pay() async {
    try {
      String txRef = TxRefRandomGenerator.generate(prefix: 'Pharmabet');

      String storedTxRef = TxRefRandomGenerator.gettxRef;

      await Chapa.getInstance.startPayment(
        context: context,
        onInAppPaymentSuccess: (successMsg) {
          print('successMsg: ' + successMsg);
        },
        onInAppPaymentError: (errorMsg) {
          print('errorMsg: ' + errorMsg);
        },
        amount: '1000',
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

  String _chapaAPI = 'CHASECK_TEST-w6sbpyY5ffpNwyQEftmEzhuL7RHj0f9d';

  Future chapapay() async {
    //--------------------------------------------------------
    // generating tx reference
    String generateTransactionReference() {
      // Custom logic for generating a transaction reference
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

      // Limit the length of the timestamp to 10 digits
      if (timestamp.length > 5) {
        timestamp = timestamp.substring(0, 10);
      }

      String transactionReference = 'chapa-$timestamp';

      return transactionReference;
    }

    //----------------------------------------------------------------
    // chapa payment
    var headers = {
      'Authorization': 'Bearer $_chapaAPI',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('https://api.chapa.co/v1/transaction/initialize'));
    request.body = json.encode({
      "amount": "1000",
      "currency": "ETB",
      "email": "abebech_bekele@gmail.com",
      "first_name": "Bilen",
      "last_name": "Gizachew",
      "phone_number": "0912345678",
      "tx_ref": generateTransactionReference(),
      "callback_url":
          "https://webhook.site/077164d6-29cb-40df-ba29-8a00e59a7e60",
      "return_url": "https://www.google.com/",
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      print(responseString);

      // Parse the JSON string
      Map<String, dynamic> jsonResponse = json.decode(responseString);

      // Access the checkout_url property
      String checkoutUrl = jsonResponse['data']['checkout_url'];

      // Print the checkout_url
      print(checkoutUrl);

      // Use url_launcher to open the URL
      final websiteUri = Uri.parse(checkoutUrl);
      return websiteUri;
      // launchUrl(websiteUri, mode: LaunchMode.inAppWebView);
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> depositvarification() async {
    var headers = {'Authorization': 'Bearer $_chapaAPI'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://api.chapa.co/v1/transaction/verify/chewatatest-6669'));
    request.body = '''''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

//----------------------------------------------------------------
  Future listofbanks() async {
    var headers = {'Authorization': 'Bearer $_chapaAPI'};
    var request =
        http.Request('GET', Uri.parse('https://api.chapa.co/v1/banks'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      List<dynamic> banks =
          json.decode(await response.stream.bytesToString())['data'];

      // Print all key-value pairs for each bank
      // banks.forEach((bank) {
      //   bank.forEach((key, value) {
      //     print('$key: ${_formatValue(value)}');
      //   });
      //   print(''); // Print an empty line between banks for better readability
      // });
      return banks;
    } else {
      print(response.reasonPhrase);
      return []; // Return an empty list in case of an error
    }
  }

// Function to format the value based on its type
  String _formatValue(dynamic value) {
    if (value is String) {
      return value;
    } else if (value is DateTime) {
      return value.toIso8601String();
    } else {
      return value.toString();
    }
  }
//----------------------------------------------------------------

  Future<void> withdrawal() async {
    var headers = {
      'Authorization': 'Bearer $_chapaAPI',
      'Content-Type': 'application/json'
    };
    var request =
        http.Request('POST', Uri.parse('https://api.chapa.co/v1/transfers'));
    request.body = json.encode({
      "account_name": "Israel Goytom",
      "account_number": "3242342332423",
      "amount": "1000",
      "currency": "ETB",
      "beneficiary_name": "Israel Goytom",
      "reference": "3241342142sfdd",
      "bank_code": "29231e51-9353-4af9-b158-01af33794f8d"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chapa payment"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'pay to Belki',
            ),
            TextButton(
                onPressed: () async {
                  await chapapay();
                },
                child: const Text("Pay")),
            TextButton(
                onPressed: () async {
                  await verify();
                },
                child: const Text("Verify")),
          ],
        ),
      ),
    );
  }
}
