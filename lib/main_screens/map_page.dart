import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

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

  call(phoneNo) async {
    final Uri phoneCall = Uri(
      scheme: 'tel',
      path: phoneNo,
    );
    await launchUrl(phoneCall, mode: LaunchMode.platformDefault);
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
          await call('4135452123');
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
  static const LatLng helpline1 = LatLng(42.3828003, -72.5233708); // 358 N Pleasant St.
  static const LatLng helpline2 = LatLng(42.3895591, -72.5199808); // Baker House
  static const LatLng helpline3 = LatLng(42.3879676, -72.531249); // Bartlett – West Side
  static const LatLng helpline4 = LatLng(42.3819085, -72.5325428); // Berkshire DC – South Side- Malcom X
  static const LatLng helpline5 = LatLng(42.3855426, -72.5315166); // Berkshire House – South Side
  static const LatLng helpline6 = LatLng(42.3880345, -72.5338728); // Birch
  static const LatLng helpline7 = LatLng(42.386225, -72.5353479); // Boyden Field – Tunnel Entrance
  static const LatLng helpline8 = LatLng(42.3894571, -72.5241368); // Brett House
  static const LatLng helpline9 = LatLng(42.3898921, -72.5235905); // Brooks House
  static const LatLng helpline10 = LatLng(42.3975058, -72.5255143); // Brown House
  static const LatLng helpline11 = LatLng(42.3940649, -72.5241485); // Burma Trail – Orchard Hill
  static const LatLng helpline12 = LatLng(42.3790682, -72.5366818); // Bus Shelter B – Stadium Rd.
  static const LatLng helpline13 = LatLng(42.395447, -72.5140719); // Bus Shelter C – Olympia Dr.
  static const LatLng helpline14 = LatLng(42.392177, -72.5376411); // Bus Shelter D – Lot 12 behind Parking Services
  static const LatLng helpline15 = LatLng(42.3798203, -72.5299287); // Bus Shelter E – Mass Ave / Sunset
  static const LatLng helpline16 = LatLng(42.388535, -72.520758); // Butterfield House
  static const LatLng helpline17 = LatLng(42.3912006, -72.5316747); // Campus Center Parking Garage – Loading Dock
  static const LatLng helpline18 = LatLng(42.3900109, -72.5253501); // Campus Pond – West Side
  static const LatLng helpline19 = LatLng(42.3810958, -72.5324821); // Cance House – Front (North Side)
  static const LatLng helpline20 = LatLng(42.3974806, -72.5243902); // Cashin House
  static const LatLng helpline21 = LatLng(42.3893424, -72.5216664); // Chadbourne House
  static const LatLng helpline22 = LatLng(42.3883976, -72.535292); // Champions Center S. West – Back Door
  static const LatLng helpline23 = LatLng(42.3920879, -72.5328105); // Chenoweth
  static const LatLng helpline24 = LatLng(42.395155, -72.5320253); // Computer Science – North Entrance
  static const LatLng helpline25 = LatLng(42.395155, -72.5320253); // Computer Science – Southwest Corner
  static const LatLng helpline26 = LatLng(42.3258149, -72.5333646); // Conte Loading Dock
  static const LatLng helpline27 = LatLng(42.3836719, -72.5324764); // Coolidge Tower
  static const LatLng helpline28 = LatLng(42.3940168, -72.5276155); // Crabtree House
  static const LatLng helpline29 = LatLng(42.383376, -72.5314189); // Crampton House
  static const LatLng helpline30 = LatLng(42.3869766, -72.5308179); // Curry Hicks
  static const LatLng helpline31 = LatLng(42.3921189, -72.5222402); // Dickinson House
  static const LatLng helpline32 = LatLng(42.3923751, -72.529093); // Draper Annex – East Side
  static const LatLng helpline33 = LatLng(42.3906299, -72.5251164); // Durfee – North Side
  static const LatLng helpline34 = LatLng(42.3953759, -72.527793); // Dwight House
  static const LatLng helpline35 = LatLng(42.3942554, -72.5318593); // ELAB II – North End
  static const LatLng helpline36 = LatLng(42.3942651, -72.531796); // ELAB II – South End
  static const LatLng helpline37 = LatLng(42.3781768, -72.5284888); // Elm East
  static const LatLng helpline38 = LatLng(42.378375, -72.524991); // Elm West
  static const LatLng helpline39 = LatLng(42.3834682, -72.5339336); // Emerson House
  static const LatLng helpline40 = LatLng(42.3916293, -72.5211382); // Field House
  static const LatLng helpline41 = LatLng(42.3894871, -72.5228677); // Franklin DC ATM
  static const LatLng helpline42 = LatLng(42.3982195, -72.5290648); // Furcolo
  static const LatLng helpline43 = LatLng(42.3848695, -72.5245028); // Gordon Hall
  static const LatLng helpline44 = LatLng(42.3886711, -72.5318386); // Goodell – Upper Entrance
  static const LatLng helpline45 = LatLng(42.3874802, -72.5235953); // Gorman House
  static const LatLng helpline46 = LatLng(42.3922361, -72.5213507); // Grayson House
  static const LatLng helpline47 = LatLng(42.3899945, -72.5218677); // Greenough House
  static const LatLng helpline48 = LatLng(42.3838499, -72.5330939); // Hampshire DC ATM
  static const LatLng helpline49 = LatLng(42.3950718, -72.5290643); // Hamlin House
  static const LatLng helpline50 = LatLng(42.3903742, -72.5242077); // Health Services – Main Entrance
  static const LatLng helpline51 = LatLng(42.387095, -72.526445); // Herter – Haigis Mall @ Bus Stop
  static const LatLng helpline52 = LatLng(42.390946, -72.545321); // ILC East – Second Floor
  // static const LatLng helpline53 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline54 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline55 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline56 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline57 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline58 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline59 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline60 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline61 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline62 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline63 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline64 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline65 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline66 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline67 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline68 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline69 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline70 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline71 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline72 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline73 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline74 = LatLng(42., -72.); // Baker House
  // static const LatLng helpline75 = LatLng(42., -72.); // Baker House





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
                    onTap: () async {
                      //SOS functionality
                      print("SOS pushed");
                      call(phoneNo) async {
                        final Uri phoneCall = Uri(
                          scheme: 'tel',
                          path: phoneNo,
                        );
                        await launchUrl(phoneCall, mode: LaunchMode.platformDefault);
                      }

                      await call('911');
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
                        //alignment: Alignment.center,
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
