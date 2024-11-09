import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:get/get.dart';
import 'package:safesteps/auth/login.dart';
import 'package:safesteps/auth/person.dart' as personModel;
import 'package:safesteps/main_screens/map_page.dart';

class AuthenticationController extends GetxController {
  static AuthenticationController authController = Get.find();
  late Rx<User?> firebaseCurrentUser;
  String? userName;

  Future<void> createNewUserAccount(String email, String password) async {
    try {
      // Authenticate user and create user with email and password
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      // Save User to FireStore Database
      personModel.Person personInstance = personModel.Person(
        uid: FirebaseAuth.instance.currentUser!.uid,
        email: email,
        password: password,
        publishedDateTime: DateTime
            .now()
            .millisecondsSinceEpoch,
      );

      await FirebaseFirestore.instance.collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(personInstance.toJson());
    } catch (errorMsg) {
      throw errorMsg
          .toString(); // Throw the error instead of showing a snackbar
    }
  }

  loginUser(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    checkIfUserIsLoggedIn(User? currentUser) async {
      if (currentUser == null) {
        Get.to(const LoginPage(), transition: Transition.fade,
            duration: const Duration(milliseconds: 400));
      } else {
        Get.to(const MapPage(), transition: Transition.fade,
            duration: const Duration(milliseconds: 400));
      }
    }

    @override
    void onReady() {
      //TODO: implement onReady
      super.onReady();

      firebaseCurrentUser = Rx<User?>(FirebaseAuth.instance.currentUser);
      firebaseCurrentUser.bindStream(FirebaseAuth.instance.authStateChanges());

    }
  }
}