import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../auth/login.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class DrawerItem {
  final String title;
  final String subTitle;
  final VoidCallback onTap;

  DrawerItem(this.title, this.subTitle, this.onTap);
}

class _MapPageState extends State<MapPage> {

  static const LatLng _pGooglePlex = LatLng(37.4223, -122.0848);
  late GoogleMapController mapController;

  Future<void> _callNumber(String number) async {
    print("Attempting to call number: $number");
    try {
      await FlutterPhoneDirectCaller.callNumber(number);
    } catch (e) {
      print("Error making call: $e");
    }
  }

  late final List<DrawerItem> drawerItems = [
    DrawerItem(
        'Share Live Location',
        'This sends your live location to contacts of your choice',
            () {
          print("Share Location tapped");
          // Navigator logic here
        }
    ),
    DrawerItem(
        'Virtual Escort',
        'Want someone from UMass Security to come to your location and walk with you to your destination?',
            () async {
          print("Virtual Escort tapped");
          await _callNumber('4132756640');
        }
    ),
    DrawerItem(
        'View UMass Map',
        'No Internet? View a pdf which shows all the help phone locations in UMass around you.',
            () {
          print("View Map tapped");
          // Navigator logic here
        }
    ),
    DrawerItem(
        'Edit',
        'Edit your information, emergency contacts, and live location feature',
            () {
          print("Edit tapped");
          Get.to(() => const LoginPage(),
              transition: Transition.fade,
              duration: const Duration(milliseconds: 400)
          );
        }
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
            children: [

              GoogleMap(
                initialCameraPosition: CameraPosition(target: _pGooglePlex, zoom: 14),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                onMapCreated: (GoogleMapController controller) { // Add this
                  mapController = controller;
                },
              ),
              // Search bar at the top with padding
              Positioned(
                top: MediaQuery.of(context).padding.top + 30,
                left: 16,
                right: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: HexColor("B7A3A3"),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Where do you want to go?',
                      hintStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Adam',
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      prefixIcon: Container(
                        padding: const EdgeInsets.all(10),
                        child: const Icon(
                          Icons.directions_walk_rounded,
                          color: Colors.black,
                        ),
                      ),
                      suffixIcon: Builder(
                        builder: (context) => IconButton(
                            onPressed: () {
                              Scaffold.of(context).openEndDrawer();
                            },
                            icon: const Icon(
                              Icons.settings,
                              color: Colors.black,
                            ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Button at the bottom
              // Positioned(
              //   bottom: 32,
              //   left: 16,
              //   right: 16,
              //   child: ElevatedButton(
              //     onPressed: () {
              //       // Add your button action here
              //     },
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.blue,
              //       foregroundColor: Colors.white,
              //       padding: const EdgeInsets.symmetric(vertical: 16),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(30),
              //       ),
              //       elevation: 5,
              //     ),
              //     child: TextField(
              //       decoration: InputDecoration(
              //         hintText: 'SOS',
              //         hintStyle: const TextStyle(
              //           fontSize: 13,
              //           fontWeight: FontWeight.normal,
              //           fontFamily: 'Adam',
              //         ),
              //         border: InputBorder.none,
              //         contentPadding: const EdgeInsets.symmetric(
              //           horizontal: 20,
              //           vertical: 15,
              //         ),
              //         prefixIcon: Container(
              //           padding: const EdgeInsets.all(10),
              //           child: const Icon(
              //             Icons.phone,
              //             color: Colors.black,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 40),
                  child: GestureDetector(
                    onTap: (){
                      //SOS functionality
                      print("SOS pushed");
                    },
                    child: Container(
                      height: 70,
                      width: 350,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.red,
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "SOS",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Adam",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),

        endDrawer: Drawer(
          width: 330,
          backgroundColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            ),
          ),
          child: Container(
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
            child: ScrollConfiguration(
              behavior: ScrollBehavior().copyWith(overscroll: false),
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 20),
                children: [
                  Container(
                    height: 150,
                    child: const Center(
                      child: Text(
                        "Settings",
                        style: TextStyle(
                          fontFamily: "Adam",
                          fontSize: 32,
                          letterSpacing: -1,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Divider(color: Colors.black.withOpacity(0.8), height: 3),
                  ...drawerItems.map((item) => AnimatedOpacity(
                    opacity: 1.0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          title: Text(
                            item.title,
                            style: TextStyle(fontFamily: "Adam", color: Colors.black.withOpacity(0.9), fontSize: 16, letterSpacing: -1),
                          ),
                          subtitle: Text(
                            item.subTitle,
                            style: TextStyle(fontFamily: "Adam", color: HexColor('3C3333').withOpacity(0.9), fontSize: 12, letterSpacing: -1),
                          ),
                          onTap: item.onTap,
                        ),
                        Divider(color: Colors.black.withOpacity(0.8), height: 3),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
