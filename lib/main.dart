import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safesteps/auth/authcontroller.dart';
import 'package:safesteps/auth/contacts_page.dart';
import 'package:safesteps/auth/login.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,  // Use this
    );
    print("Firebase initialized successfully");
    Get.put(AuthenticationController());
  } catch (e) {
    print("Failed to initialize Firebase: $e");
  }

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