import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:get/get.dart';
import 'package:safesteps/auth/contacts_page.dart';
import 'package:safesteps/auth/login.dart';

import '../widgets/custom_text_field_widget.dart';
import 'authcontroller.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  var authenticationController = AuthenticationController.authController;
  bool _obscureText = true;

  // text editing controllers
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  bool isUniversityEmail(String email) {
    if (email.toLowerCase().endsWith('.edu')) {
      return true;
    }
    return false;
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
              "SafeSteps",
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
              const SizedBox(height: 150,),
              //email
              const Padding(
                padding: EdgeInsets.only(left: 55),
                child: Text(
                  "Email (University Email)",
                  style: TextStyle(
                    color: textColor,
                    letterSpacing: -1,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Adam',
                  ),
                ),
              ),

              const SizedBox(height: 10),

              //emailTextEditingController
              CustomTextFieldWidget(
                editingController: emailTextEditingController,
                labelText: "",
                isObscure: false,
                //width: 75,
              ),

              const SizedBox(height: 10,),

              //password
              const Padding(
                padding: EdgeInsets.only(left: 55),
                child: Text(
                  "Password",
                  style: TextStyle(
                    color: textColor,
                    letterSpacing: -1,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Adam',
                  ),
                ),
              ),

              const SizedBox(height: 10),

              //passwordTextEditingController
              CustomTextFieldWidget(
                editingController: passwordTextEditingController,
                labelText: "",
                isObscure: _obscureText,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black,
                  ),
                  onPressed: _toggleObscureText,
                ),
                //width: 75,
              ),

              Padding(
                padding: const EdgeInsets.only(left: 55),
                child: InkWell(
                  onTap: (){
                    Get.to(const LoginPage(), transition: Transition.fade, duration: const Duration(milliseconds: 400));
                  },
                  child: const Text(
                    'Login?',
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: -1,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Adam',
                    ),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 32),
                  child: GestureDetector(
                    onTap: () async {
                      if (emailTextEditingController.text.trim().isNotEmpty
                        && passwordTextEditingController.text.trim().isNotEmpty) {

                        if (!isUniversityEmail(emailTextEditingController.text.trim())) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please use a valid university email address.',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Adam',
                                ),
                              ),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          return;
                        }

                        try {
                          await authenticationController
                            .createNewUserAccount(
                              emailTextEditingController.text.trim(),
                              passwordTextEditingController.text.trim(),
                            );
                          Get.to(
                            const ContactsPage(),
                            transition: Transition.fade,
                            duration: const Duration(milliseconds: 400),
                          );
                        } catch (error) {
                          print(error);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Account creation failed: $error',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Adam',
                                ),
                              ),
                              duration: const Duration(seconds: 4),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'A Field is empty. Please fill out all text fields.',
                              style: TextStyle(
                                fontSize: 16,
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
                        "Sign Up",
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
            ]
          ),
        ),
      ),
    );
  }
}
