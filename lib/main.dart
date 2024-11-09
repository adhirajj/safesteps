import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesteps/auth/authcontroller.dart';
import 'package:safesteps/auth/login.dart';
import 'package:safesteps/auth/signup.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase first
  try {
    await Firebase.initializeApp();
    print("Firebase initialized successfully");
  } catch (e) {
    print("Failed to initialize Firebase: $e");
  }

  // Initialize GetX controller
  Get.put(AuthenticationController(), permanent: true);

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: BindingsBuilder(() {
        Get.put(AuthenticationController(), permanent: true);
      }),
      theme: ThemeData(
        useMaterial3: true,
        dividerColor: Colors.transparent,
      ),
      themeMode: ThemeMode.system,
      home: const LoginPage(),
    );
  }
}