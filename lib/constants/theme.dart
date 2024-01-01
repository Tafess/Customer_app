// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

ThemeData themeData = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  primaryColor: Colors.blue,
  primarySwatch: Colors.green,
  canvasColor: Colors.red,

  ////////////////////////////////////////////////
  inputDecorationTheme: InputDecorationTheme(
      // border: outlineInputBorder,
      // errorBorder: outlineInputBorder,
      // enabledBorder: outlineInputBorder,
      // focusedBorder: outlineInputBorder,
      // disabledBorder: outlineInputBorder,
      prefixIconColor: Colors.blue,
      suffixIconColor: Colors.green,
      fillColor: Colors.white,
      filled: true),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.red,
      backgroundColor: Colors.white,
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),

      disabledForegroundColor: Colors.blue.shade100,
      disabledBackgroundColor: Colors.grey, // Add this line
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue.shade300,
      disabledBackgroundColor: Colors.grey, // Add this line
      textStyle: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white70,
    elevation: 0,
    titleSpacing: 1,
    titleTextStyle: TextStyle(
        fontSize: 22, color: Colors.grey.shade700, fontWeight: FontWeight.bold),
    iconTheme: IconThemeData(color: Colors.blue),
  ),
);

// OutlineInputBorder outlineInputBorder = const OutlineInputBorder(
//   // borderSide: BorderSide(

//   //   color: Colors.grey,
//   //   //style: BorderStyle.solid,
//   //   width: 1,
//   // ),
//   borderRadius: BorderRadius.all(Radius.circular(12.0)),
// );

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade50,
    primary: Colors.white70,
    secondary: Colors.black,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey.shade400,
    foregroundColor: Colors.black,
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Colors.grey.shade800,
    primary: Colors.grey.shade700,
    secondary: Colors.white,
  ),
  appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey.shade700, foregroundColor: Colors.white),
  cardColor: Colors.grey.shade500,
);
//#212121
//#263238
//#424242

