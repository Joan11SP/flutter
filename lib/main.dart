import 'package:flutter/material.dart';
import 'package:nannys/src/pages/map.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var materialApp = MaterialApp(
        themeMode:ThemeMode.dark,
        title: 'Ala Orden',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            appBarTheme: AppBarTheme(
          color: Color(0xFF01579B),
        )),
        home: MapOpen());
    return materialApp;
  }
}
