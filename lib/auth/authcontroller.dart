import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:get/get.dart';
import 'package:safesteps/auth/contacts_page.dart';
import 'package:safesteps/auth/login.dart';
import 'package:safesteps/auth/person.dart' as personModel;
import 'package:safesteps/main_screens/map_page.dart';

class AuthenticationController extends GetxController {
  static AuthenticationController authController = Get.find();
  late Rx<User?> firebaseCurrentUser;
  String? userName;
  String get currentUserId => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void onInit() {
    super.onInit();
    // Initialize any required variables or services
  }

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

  userContacts(String contact1, String contact2, String contact3, String contact4, String contact5, String contact6) async {
    if (contact1.isNotEmpty
        && contact2.isNotEmpty
        && contact3.isNotEmpty
        && contact4.isNotEmpty
        && contact5.isNotEmpty
        && contact6.isNotEmpty
    ) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .set(
        {
          'contact1': contact1,
          'contact2': contact2,
          'contact3': contact3,
          'contact4': contact4,
          'contact5': contact5,
          'contact6': contact6,
        }
      );

      return true;
    } else{
      return false;
    }
  }

  Future<List<String?>> getUserContacts() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .get();

      if (userDoc.exists) {
        return [
          userDoc.get('contact1') as String?,
          userDoc.get('contact2') as String?,
          userDoc.get('contact3') as String?,
          userDoc.get('contact4') as String?,
          userDoc.get('contact5') as String?,
          userDoc.get('contact6') as String?,
        ];
      } else {
        throw Exception("User document does not exist");
      }
    } catch (error) {
      print("Error retrieving contacts: $error");
      return []; // Return an empty list or handle the error accordingly
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