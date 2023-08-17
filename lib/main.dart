import 'package:flutter/material.dart';
import 'package:tree_tracker/theme/app_color.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tree Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: AppColor.secondary,
            primary: Colors.green,
            brightness: Brightness.light),
      ),
      home: const HomeScreen()
    );
  }
}