import 'package:buyers/constants/theme.dart';
import 'package:buyers/controllers/firebase_auth_helper.dart';
import 'package:buyers/firebase_options.dart';
import 'package:buyers/providers/app_provider.dart';
import 'package:buyers/screens/welcome.dart';
import 'package:buyers/widgets/bottom_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51OFnrbL5s11I9QDMOFtPyDVhgwlglgvExwrsPoeZwvmFJa3hv6kdqMY06muBIWP3OgnqOGeQpMwmzOocYcWECL8k00hpdzUzvM';
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Belkis ',
        theme: themeData,
        home: StreamBuilder(
            stream: FirebaseAuthHelper.instance.getAuthChange,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const CustomBottomBar();
              } else {
                return const Welcome();
              }
            }),
      ),
    );
  }
}
