import 'package:backup_app/Controls/Constants.dart';
import 'package:flutter/material.dart';
import 'Screen/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flare Shot',
      theme: themeData,
      routes: routes,
      initialRoute: HomeScreen.route,
    );
  }
}
