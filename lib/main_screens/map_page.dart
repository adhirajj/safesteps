import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

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

  static const LatLng _pHagisMall = LatLng(42.3863, -72.5258);
  late GoogleMapController mapController;
  LocationData? currentLocation;

  void getCurrentLocation() async {
    Location location = Location();

    try {
      location.getLocation().then(
            (location) {
          setState(() {  // Add setState here
            currentLocation = location;
            print("Current Location yessirrrr: $currentLocation");
          });
        },
      );

      // Also listen for location changes
      location.onLocationChanged.listen(
            (LocationData newLocation) {
          setState(() {
            currentLocation = newLocation;
            print("Updated Location: $currentLocation");
          });
        },
      );
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

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

  // helpLines
  static const LatLng helpline1 = LatLng(42.382830, -72.520950); // 358 N Pleasant St.
  static const LatLng helpline2 = LatLng(42.3895, -72.5198); // Baker House
  static const LatLng helpline3 = LatLng(42.340382, -72.496819); // Bartlett- WestSide
  //static const LatLng helpline4 = LatLng(42., -72.); // Berkshire DC
  // static const LatLng helpline5 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline6 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline7 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline8 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline9 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline10 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline11 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline12 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline13 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline14 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline15 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline16 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline17 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline18 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline19 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline20 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline21 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline22 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline23 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline24 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline25 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline26 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline27 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline28 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline29 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline30 = LatLng(42., -72.); // Baker House

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
            children: [

              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: currentLocation == null ? Center(child: Text("Loading..."),) : GoogleMap(
                  initialCameraPosition: CameraPosition(target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!), zoom: 15),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                    print("Map Controller created");
                  },
                  markers: {
                    Marker(
                      markerId: MarkerId("358 N Pleasant St."),
                      icon: BitmapDescriptor.defaultMarker,
                      position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
                    ),
                  },
                ),
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
                        color: HexColor("#881C1C"),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child:
                        Row(
                          children: [
                            SizedBox(width: 20,),

                            Align(
                              alignment: Alignment.center,
                              child: Image.asset(
                                  "lib/icons/call.png",
                                height: 40,
                              ),
                            ),

                            SizedBox(width: 85,),

                            Align(
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
                          ],
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
