import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final TextEditingController? editingController;
  final IconData? iconData;
  final String? assetRef;
  final String? labelText;
  final bool isObscure;
  final Widget? suffixIcon;

  const CustomTextFieldWidget({
    super.key,
    this.editingController,
    this.iconData,
    this.assetRef,
    this.labelText,
    this.isObscure = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    // final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // final textColor = isDarkMode ? Colors.white : Colors.black;

    return Center(
      child: SizedBox(
        height: 70,
        width: 350,
        child: TextFormField(
          controller: editingController,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'Adam',
          ),
          cursorColor: Colors.black,
          decoration: InputDecoration(
            labelText: labelText,
            alignLabelWithHint: true,
            filled: true,
            fillColor: HexColor('B7A3A3'),
            labelStyle: const TextStyle(
              color: Colors.black,
              fontSize: 10,
              fontFamily: 'Adam',
            ),
            floatingLabelAlignment: FloatingLabelAlignment.center,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10),
            suffixIcon: suffixIcon,
          ),
          obscureText: isObscure,
        ),
      ),
    );
  }
}