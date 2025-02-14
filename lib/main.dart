import 'package:flutter/material.dart';
import 'package:flutter_dunya_ulkeleri/Anasayfa.dart';

void main() {
  runApp(AnaUygulama());
}

class AnaUygulama extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Anasayfa(),
      debugShowCheckedModeBanner: false,
    );
  }
}
