import 'package:flutter/material.dart';
import 'package:nannys/src/pages/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Niñeras',
      debugShowCheckedModeBanner: false,
      home: LoginPage()
    );
  }
}


