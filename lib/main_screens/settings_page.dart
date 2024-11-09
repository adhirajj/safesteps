// import 'package:flutter/material.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
// import 'package:get/get.dart';
//
// import '../auth/login.dart';
//
// _callNumber(String number) async{
//   await FlutterPhoneDirectCaller.callNumber(number);
// }
//
// final List<DrawerItem> drawerItems = [
//   DrawerItem('Share Live Location', 'This sends your live location to contacts of your choice', () {
//     // Navigator logic here
//     print("func 1");
//   }),
//   DrawerItem('Virtual Escort', 'Want someone from UMass Security to come to your location and walk with you to your destination?', _callNumber('4132756640'),),
//   DrawerItem('View UMass Map', 'No Internet? View a pdf which shows all the help phone locations in UMass around you.', () {
//     // Navigator logic here
//   }),
//   DrawerItem('Edit', 'Edit your information, emergency contacts, and live location feature', () {
//     // Navigator logic here
//     Get.to(const LoginPage(), transition: Transition.fade, duration: const Duration(milliseconds: 400));
//   }),
// ];
//
// class DrawerItem {
//   final String title;
//   final String subTitle;
//   final VoidCallback onTap;
//
//   DrawerItem(this.title, this.subTitle, this.onTap);
// }