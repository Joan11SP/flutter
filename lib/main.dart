import 'package:flutter/material.dart';
import 'package:nannys/src/pages/map.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ala Orden',
      debugShowCheckedModeBanner: false,
      home: MapOpen()
    );
  }
}


