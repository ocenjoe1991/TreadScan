import 'package:flutter/material.dart';
import 'ui/home_page.dart';

void main() {
  runApp(const TreadScanApp ());
}

class TreadScanApp  extends StatelessWidget {
  const TreadScanApp ({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TreadScan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(), // HomePage
    );
  }
}

