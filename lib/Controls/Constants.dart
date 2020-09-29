import 'package:backup_app/Screen/change_ip_address.dart';
import 'package:backup_app/Screen/custom_path_screen.dart';
import 'package:backup_app/Screen/home_screen.dart';
import 'package:flutter/material.dart';

// #2979ff
const Color whiteColor = Colors.white;
const Color accentColor = Color(0xFF2979ff);
String serverUrl = "http://192.168.1.89:3000";

const String ipString = "ip";
const cameraServerUrl = "/Camera";
const MisServerUrl = "/Mis";
const screenShotServerUrl = "/Screenshots";
const String cameraPath = "/DCIM/Camera";
const String downloadPath = "/Download";
const String screenshotPath = "/Pictures/Screenshots";

final ThemeData themeData = ThemeData(
  inputDecorationTheme: InputDecorationTheme(
    fillColor: whiteColor,
    labelStyle: TextStyle(color: Colors.blueAccent),
    enabledBorder: outlineInputBorder(1),
    focusedBorder: outlineInputBorder(2),
  ),
  indicatorColor: whiteColor,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: accentColor,
  ),
  appBarTheme: AppBarTheme(
    color: accentColor,
  ),
  accentColor: accentColor,
);

OutlineInputBorder outlineInputBorder(double width) => OutlineInputBorder(
      borderSide: BorderSide(
        color: accentColor,
        style: BorderStyle.solid,
        width: width,
      ),
      borderRadius: BorderRadius.circular(
        10,
      ),
    );

final Map<String, Widget Function(BuildContext)> routes = {
  HomeScreen.route: (_) => HomeScreen(),
  ChangeIpAddress.route: (_) => ChangeIpAddress(),
  CustomPathScreen.route: (_) => CustomPathScreen(),
};
