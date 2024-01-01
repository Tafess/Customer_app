// ignore_for_file: prefer_const_constructors

import 'package:buyers/controllers/firebase_auth_helper.dart';
import 'package:buyers/firebase_options.dart';
import 'package:buyers/l10n/l10n.dart';
import 'package:buyers/local_strings.dart';
import 'package:buyers/providers/app_provider.dart';
import 'package:buyers/providers/theme_provider.dart';
import 'package:buyers/screens/welcome.dart';
import 'package:buyers/widgets/bottom_bar.dart';
import 'package:chapa_unofficial/chapa_unofficial.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Chapa.configure(privateKey: "CHASECK_TEST-w6sbpyY5ffpNwyQEftmEzhuL7RHj0f9d");
  // Stripe.publishableKey =
  //     'pk_test_51OFnrbL5s11I9QDMOFtPyDVhgwlglgvExwrsPoeZwvmFJa3hv6kdqMY06muBIWP3OgnqOGeQpMwmzOocYcWECL8k00hpdzUzvM';
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        translations: LocalStrings(),
        locale: Locale('en', 'US'),
        title: 'Belkis ',
        theme: Provider.of<ThemeProvider>(context).themeData,
        home: StreamBuilder(
            stream: FirebaseAuthHelper.instance.getAuthChange,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CustomBottomBar();
              } else {
                return const Welcome();
              }
            }),
      ),
    );
  }
}

// class MyMap extends StatefulWidget {
//   @override
//   _MyMapState createState() => _MyMapState();
// }

// class _MyMapState extends State<MyMap> {
//   final loc.Location location = loc.Location();
//   StreamSubscription<loc.LocationData>? _locationSubscription;

//   @override
//   void initState() {
//     super.initState();
//     _requestPermission();
//     location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
//     location.enableBackgroundMode(enable: true);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('live location tracker'),
//       ),
//       body: Column(
//         children: [
//           TextButton(
//               onPressed: () {
//                 _getLocation();
//               },
//               child: Text('add my location')),
//           TextButton(
//               onPressed: () {
//                 _listenLocation();
//               },
//               child: Text('enable live location')),
//           TextButton(
//               onPressed: () {
//                 _stopListening();
//               },
//               child: Text('stop live location')),
//           Expanded(
//               child: StreamBuilder(
//             stream:
//                 FirebaseFirestore.instance.collection('location').snapshots(),
//             builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//               if (!snapshot.hasData) {
//                 return Center(child: CircularProgressIndicator());
//               }
//               return ListView.builder(
//                   itemCount: snapshot.data?.docs.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       title:
//                           Text(snapshot.data!.docs[index]['name'].toString()),
//                       subtitle: Row(
//                         children: [
//                           Text(snapshot.data!.docs[index]['latitude']
//                               .toString()),
//                           SizedBox(
//                             width: 20,
//                           ),
//                           Text(snapshot.data!.docs[index]['longitude']
//                               .toString()),
//                         ],
//                       ),
//                       trailing: IconButton(
//                         icon: Icon(Icons.directions),
//                         onPressed: () {
//                           Navigator.of(context).push(MaterialPageRoute(
//                               builder: (context) =>
//                                   MapScreen()));
//                         },
//                       ),
//                     );
//                   });
//             },
//           )),
//         ],
//       ),
//     );
//   }

//   _getLocation() async {
//     try {
//       final loc.LocationData _locationResult = await location.getLocation();
//       await FirebaseFirestore.instance.collection('location').doc('user1').set({
//         'latitude': _locationResult.latitude,
//         'longitude': _locationResult.longitude,
//         'name': 'john'
//       }, SetOptions(merge: true));
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> _listenLocation() async {
//     _locationSubscription = location.onLocationChanged.handleError((onError) {
//       print(onError);
//       _locationSubscription?.cancel();
//       setState(() {
//         _locationSubscription = null;
//       });
//     }).listen((loc.LocationData currentlocation) async {
//       await FirebaseFirestore.instance.collection('location').doc('user1').set({
//         'latitude': currentlocation.latitude,
//         'longitude': currentlocation.longitude,
//         'name': 'john'
//       }, SetOptions(merge: true));
//     });
//   }

//   _stopListening() {
//     _locationSubscription?.cancel();
//     setState(() {
//       _locationSubscription = null;
//     });
//   }

//   _requestPermission() async {
//     var status = await Permission.location.request();
//     if (status.isGranted) {
//       print('done');
//     } else if (status.isDenied) {
//       _requestPermission();
//     } else if (status.isPermanentlyDenied) {
//       openAppSettings();
//     }
//   }
// }
