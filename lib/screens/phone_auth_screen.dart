// import 'package:buyers/constants/custome_button.dart';
// import 'package:buyers/screens/pin_input_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class PhoneAuthScreen extends StatefulWidget {
//   @override
//   _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
// }

// class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
//   TextEditingController _phoneController = TextEditingController();
//   FirebaseAuth _auth = FirebaseAuth.instance;
//   String verificationId = "";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Phone Authentication"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: TextField(
//                 controller: _phoneController,
//                 keyboardType: TextInputType.phone,
//                 decoration: InputDecoration(
//                   hintText: "Enter your phone number",
//                 ),
//               ),
//             ),
//             CustomButton(
//                 onPressed: () async {
//                   await _verifyPhoneNumber(_phoneController.text);
//                 },
//                 title: 'SEND SMS'),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => CustomPinInput(
//                             verificationId: '',
//                           )),
//                 );
//               },
//               child: Text("Go to PIN Input"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _verifyPhoneNumber(String phoneNumber) async {
//     try {
//       await _auth.verifyPhoneNumber(
//         phoneNumber: phoneNumber,
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           await _auth.signInWithCredential(credential);
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           print("Verification failed: $e");
//         },
//         codeSent: (String verificationId, int? resendToken) {
//           setState(() {
//             this.verificationId = verificationId;
//           });
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) =>
//                   CustomPinInput(verificationId: verificationId),
//             ),
//           );
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {
//           print("Auto retrieval timeout");
//         },
//         timeout: Duration(seconds: 60),
//       );
//     } catch (e) {
//       print("Failed to verify phone number: $e");
//       // Handle the failure, such as showing an error message
//     }
//   }
// }

// ignore_for_file: prefer_const_constructors

import 'package:buyers/constants/custom_routes.dart';
import 'package:buyers/constants/custom_text.dart';
import 'package:buyers/constants/custome_button.dart';
import 'package:buyers/screens/login.dart';
import 'package:buyers/screens/pin_input_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneAuthScreen extends StatefulWidget {
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  TextEditingController _otpController = TextEditingController();
  String? initialCountry = 'ET';
  String verificationId = "";
  PhoneNumber? phoneNumber;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: IconButton(
              onPressed: () {
                Routes.instance.push(widget: Login(), context: context);
              },
              icon: Icon(Icons.arrow_back)),
        ),
        body: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: text(
                      title: 'Sign in with your Phone number',
                      size: 28,
                      color: Colors.blue),
                )),
                Image.asset(
                  'assets/icons/phone.png',
                  width: 150,
                  height: 150,
                ),
                SizedBox(height: 40),
                text(
                    title:
                        ' Enter your phone number in the field bellow\nWe will send 6 digit sms message to your phone'),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      setState(() {
                        phoneNumber = number;
                      });
                    },
                    onInputValidated: (bool value) {
                      // Handle phone number validation if needed.
                    },
                    selectorConfig: SelectorConfig(
                        selectorType: PhoneInputSelectorType.DIALOG,
                        useBottomSheetSafeArea: true),
                    ignoreBlank: false,
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    selectorTextStyle: TextStyle(color: Colors.black),
                    initialValue: PhoneNumber(isoCode: initialCountry),
                    textFieldController: _otpController,
                    formatInput: false,
                    keyboardType: TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputDecoration: InputDecoration(
                      hintText: "Enter your phone number",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                  child: Container(
                    width: double.infinity,
                    child: CustomButton(
                      onPressed: () async {
                        await _verifyPhoneNumber(phoneNumber!.phoneNumber!);
                      },
                      title: 'SEND SMS',
                    ),
                  ),
                ),
                SizedBox(height: 20),
               
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _verifyPhoneNumber(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Verification failed: $e");
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            this.verificationId = verificationId;
          });
          // After receiving the verificationId, navigate to the PIN input screen
          Routes.instance.push(
              widget: CustomPinInput(verificationId: verificationId),
              context: context);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("Auto retrieval timeout");
        },
        timeout: Duration(seconds: 60),
      );
    } catch (e) {
      print("Failed to verify phone number: $e");
      
    }
  }

}
