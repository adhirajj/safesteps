import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:get/get.dart';
import 'package:safesteps/auth/authcontroller.dart';
import 'package:safesteps/auth/login.dart';
import 'package:safesteps/auth/signup.dart';
import 'package:safesteps/main_screens/map_page.dart';

import '../widgets/custom_text_field_widget.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {

  final authenticationController = Get.find<AuthenticationController>();
  bool showProgressBar = false;
  var auth = FirebaseAuth.instance;

  // text editing controllers
  TextEditingController contact1TextEditingController = TextEditingController();
  TextEditingController contact2TextEditingController = TextEditingController();
  TextEditingController contact3TextEditingController = TextEditingController();
  TextEditingController contact4TextEditingController = TextEditingController();
  TextEditingController contact5TextEditingController = TextEditingController();
  TextEditingController contact6TextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var brightness = MediaQuery.of(context).platformBrightness;
    // bool isDarkMode = brightness == Brightness.dark;
    // final titleColor = isDarkMode ? Colors.white : Colors.black;
    // final textColor = isDarkMode ? Colors.black : Colors.white;
    const textColor = Colors.black;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: HexColor('E3ADAD').withOpacity(0.9),
        automaticallyImplyLeading: false,
        toolbarHeight: 160,
        elevation: 0,
        flexibleSpace: const Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 20, bottom: 20),
            child: Text(
              "Edit Emergency \nContacts",
              style: TextStyle(
                color: textColor,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'Adam',
              ),
            ),
          ),
        ),
      ),

      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              HexColor('E3ADAD').withOpacity(0.9),
              HexColor('881C1C').withOpacity(0.9),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50,),

                //Emergency SOS contacts
                const Padding(
                  padding: EdgeInsets.only(left: 45),
                  child: Text(
                    "Emergency Contacts",
                    style: TextStyle(
                      color: textColor,
                      letterSpacing: -1,
                      fontSize: 22,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Adam',
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 45),
                  child: Text(
                    "These are people we'll send a text alert to along with calling 911 \nif and when you press the SOS button",
                    style: TextStyle(
                      color: Colors.black54,
                      letterSpacing: -1,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Adam',
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                //contact1
                const Padding(
                  padding: EdgeInsets.only(left: 50),
                  child: Text(
                    "Contact 1",
                    style: TextStyle(
                      color: textColor,
                      letterSpacing: -1,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Adam',
                    ),
                  ),
                ),

                SizedBox(height: 5,),

                CustomTextFieldWidget(
                  editingController: contact1TextEditingController,
                  labelText: "",
                  //width: 75,
                ),

                const SizedBox(height: 10,),

                //contact2
                const Padding(
                  padding: EdgeInsets.only(left: 50),
                  child: Text(
                    "Contact 2",
                    style: TextStyle(
                      color: textColor,
                      letterSpacing: -1,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Adam',
                    ),
                  ),
                ),

                const SizedBox(height: 5,),

                CustomTextFieldWidget(
                  editingController: contact2TextEditingController,
                  labelText: "",
                  //width: 75,
                ),

                const SizedBox(height: 10,),

                //contact3
                const Padding(
                  padding: EdgeInsets.only(left: 50),
                  child: Text(
                    "Contact 3",
                    style: TextStyle(
                      color: textColor,
                      letterSpacing: -1,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Adam',
                    ),
                  ),
                ),

                const SizedBox(height: 5,),

                CustomTextFieldWidget(
                  editingController: contact3TextEditingController,
                  labelText: "",
                  //width: 75,
                ),

                const SizedBox(height: 15,),

                //Live Location contacts
                const Padding(
                  padding: EdgeInsets.only(left: 45),
                  child: Text(
                    "Live Location Contacts",
                    style: TextStyle(
                      color: textColor,
                      letterSpacing: -1,
                      fontSize: 22,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Adam',
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 45),
                  child: Text(
                    "These are people we'll send your live location to on pressing the ShareLiveLocation Button",
                    style: TextStyle(
                      color: Colors.black54,
                      letterSpacing: -1,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Adam',
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                //contact4
                const Padding(
                  padding: EdgeInsets.only(left: 50),
                  child: Text(
                    "Contact 1",
                    style: TextStyle(
                      color: textColor,
                      letterSpacing: -1,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Adam',
                    ),
                  ),
                ),

                const SizedBox(height: 5,),

                CustomTextFieldWidget(
                  editingController: contact4TextEditingController,
                  labelText: "",
                  //width: 75,
                ),

                const SizedBox(height: 10,),

                //contact5
                const Padding(
                  padding: EdgeInsets.only(left: 50),
                  child: Text(
                    "Contact 2",
                    style: TextStyle(
                      color: textColor,
                      letterSpacing: -1,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Adam',
                    ),
                  ),
                ),

                const SizedBox(height: 5,),

                CustomTextFieldWidget(
                  editingController: contact5TextEditingController,
                  labelText: "",
                  //width: 75,
                ),

                const SizedBox(height: 10,),

                //contact6
                const Padding(
                  padding: EdgeInsets.only(left: 50),
                  child: Text(
                    "Contact 3",
                    style: TextStyle(
                      color: textColor,
                      letterSpacing: -1,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Adam',
                    ),
                  ),
                ),

                const SizedBox(height: 5,),

                CustomTextFieldWidget(
                  editingController: contact6TextEditingController,
                  labelText: "",
                  //width: 75,
                ),

                const SizedBox(height: 10,),

                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 32),
                    child: GestureDetector(
                      onTap: () async {
                        if (contact1TextEditingController.text.trim().isNotEmpty
                            && contact2TextEditingController.text.trim().isNotEmpty
                            && contact3TextEditingController.text.trim().isNotEmpty
                            && contact4TextEditingController.text.trim().isNotEmpty
                            && contact5TextEditingController.text.trim().isNotEmpty
                            && contact6TextEditingController.text.trim().isNotEmpty
                        )
                        {
                          setState(() {
                            showProgressBar = true;
                          });

                          setState(() {
                            showProgressBar = false;
                          });

                          try {
                            authenticationController.userContacts(
                              contact1TextEditingController.text.trim(),
                              contact2TextEditingController.text.trim(),
                              contact3TextEditingController.text.trim(),
                              contact4TextEditingController.text.trim(),
                              contact5TextEditingController.text.trim(),
                              contact6TextEditingController.text.trim(),
                            );
                            Get.back();
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Contact saving failed: $error',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Adam',
                                  ),
                                ),
                                duration: const Duration(seconds: 4),
                              ),
                            );
                          } finally {
                            setState(() {
                              showProgressBar = false;
                            });
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'A Field is empty. Please fill out all text fields.',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Adam',
                                ),
                              ),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),  //20, 10
                        decoration: BoxDecoration(
                          color: HexColor('DEA5A5'),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(
                            letterSpacing: -1,
                            fontSize: 16,
                            fontFamily: 'Adam',
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                showProgressBar == true
                    ? Align(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
                  ),
                )
                    : Container(),

                SizedBox(height: 50,),
              ]
          ),
        ),
      ),
    );
  }
}
