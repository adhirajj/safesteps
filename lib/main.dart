import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesteps/auth/authcontroller.dart';
import 'package:safesteps/auth/login.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    print("Firebase initialized successfully");
    Get.put(AuthenticationController());
  } catch (e) {
    print("Failed to initialize Firebase: $e");
  }

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