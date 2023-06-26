import 'package:blue_locator/src/features/home/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BleTrackerApp());
}

class BleTrackerApp extends StatelessWidget {
  const BleTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLE Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
