import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesteps/auth/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        dividerColor: Colors.transparent,
      ),
      themeMode: ThemeMode.system, // This will follow the system theme
      home: const LoginPage(),
    );
  }
}