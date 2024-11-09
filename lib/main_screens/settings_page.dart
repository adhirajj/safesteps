import 'package:flutter/material.dart';
import 'package:get/get.dart';

final List<DrawerItem> drawerItems = [
  DrawerItem('Share Live Location', 'This sends your live location to contacts of your choice', () {
    // Navigator logic here
  }),
  DrawerItem('Virtual Escort', 'Want someone from UMass Security to come to your location and walk with you to your destination?', () {
    // Navigator logic here
  }),
  DrawerItem('View UMass Map', 'No Internet? View a pdf which shows all the help phone locations in UMass around you.', () {
    // Navigator logic here
  }),
  DrawerItem('Edit', 'Edit your information, emergency contacts, and live location feature', () {
    // Navigator logic here
  }),
];

class DrawerItem {
  final String title;
  final String subTitle;
  final VoidCallback onTap;

  DrawerItem(this.title, this.subTitle, this.onTap);
}