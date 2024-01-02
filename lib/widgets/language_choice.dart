import 'package:buyers/constants/custom_routes.dart';
import 'package:buyers/screens/welcome.dart';
import 'package:buyers/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageDialog extends StatelessWidget {
  final List<Map<String, Object>> locales = [
    {'name': 'English', 'locale': Locale('en', 'US')},
    {'name': 'አማርኛ', 'locale': Locale('am', 'ET')},
    {'name': 'Afaan Oromo', 'locale': Locale('om', 'ET')},
  ];

  void updateLanguage(Locale local) {
    Get.back();
    Get.updateLocale(local);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Language'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: locales.map((locale) {
          return ListTile(
            title: Text(locale['name'] as String),
            onTap: () {
              updateLanguage(locale['locale'] as Locale);
              Routes.instance.push(widget: Welcome(), context: context);
            },
          );
        }).toList(),
      ),
    );
  }
}
