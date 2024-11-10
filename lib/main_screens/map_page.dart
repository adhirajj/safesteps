import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:safesteps/main_screens/edit_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../auth/authcontroller.dart';
import '../auth/login.dart';
import 'dart:async';
import 'package:safesteps/main_screens/umass_pdf_page.dart';
import 'package:telephony_sms/telephony_sms.dart';

import '../global.dart';

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
  BitmapDescriptor? customIcon;
  TextEditingController _searchController = TextEditingController();
  Set<Polyline> _polylines = {};
  Marker? destinationMarker;
  List<PlaceSuggestion> _suggestions = [];
  bool _showSuggestions = false;
  Timer? _debounce;

  final telephonySMS = TelephonySMS();

  Future<List<String?>> contacts = AuthenticationController.authController.getUserContacts();
  String? contact1;
  String? contact2;
  String? contact3;
  String? contact4;
  String? contact5;
  String? contact6;

  Future<void> loadCustomIcon() async {
    BitmapDescriptor.asset(
      ImageConfiguration(size: Size(28, 28)),  // Adjust size as needed
      "lib/icons/call.png",
    ).then((icon) {
      setState(() {
        customIcon = icon;
      });
    });
  }

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
    loadCustomIcon();
    
    contacts.then((onValue) => {
      setState(() {
        contact1 = onValue[0];
        contact2 = onValue[1];
        contact3 = onValue[2];
        contact4 = onValue[3];
        contact5 = onValue[4];
        contact6 = onValue[5];
      })
    });
  }

  call(phoneNo) async {
    final Uri phoneCall = Uri(
      scheme: 'tel',
      path: phoneNo,
    );
    await launchUrl(phoneCall, mode: LaunchMode.platformDefault);
  }

  late final List<DrawerItem> drawerItems = [
    // DrawerItem(
    //     'Share Live Location',
    //     'This sends your live location to contacts of your choice',
    //         () async {
    //           await telephonySMS.requestPermission();
    //           print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    //           await telephonySMS.sendSMS(phone: contact4!, message: "Live Location test");
    //           print("finished first message send");
    //           await telephonySMS.sendSMS(phone: contact5!, message: "Live Location");
    //           print("finished second message send");
    //           await telephonySMS.sendSMS(phone: contact6!, message: "Live Location");
    //     }
    // ),
    DrawerItem(
        'Share Live Location',
        'This sends your live location to contacts of your choice',
            () async {
          try {
            await telephonySMS.requestPermission();

            await telephonySMS.sendSMS(phone: contact5!, message: "Live Location test");
            print("First message sent");

            await Future.delayed(Duration(seconds: 1)); // Add delay

            await telephonySMS.sendSMS(phone: contact4!, message: "Live Location");
            print("Second message sent");

            await Future.delayed(Duration(seconds: 1)); // Add delay

            await telephonySMS.sendSMS(phone: contact6!, message: "Live Location");
            print("Third message sent");
          } catch (e) {
            print("Error: $e");
          }
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
          Get.to(
                () => const PdfViewerPage(),
            transition: Transition.fade,
            duration: const Duration(milliseconds: 400),
          );
        }
    ),
    DrawerItem(
        'Edit',
        'Edit your information, emergency contacts, and live location feature',
            () {
          Get.to(() => const EditPage(),
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
  static const LatLng helpline53 = LatLng(42.391435, -72.526266); // ILC North – First Floor
  static const LatLng helpline54 = LatLng(42.390866, -72.526293); // ILC West – Second Floor
  static const LatLng helpline55 = LatLng(42.392359, -72.525210); // ISB East
  static const LatLng helpline56 = LatLng(42.392806, -72.524902); // ISB East – Second Floor
  static const LatLng helpline57 = LatLng(42.392449, -72.524736); // ISB West
  static const LatLng helpline58 = LatLng(42.3841787, -72.5337553); // James House
  static const LatLng helpline59 = LatLng(42.3818423, -72.5312886); // John Adams Tower
  static const LatLng helpline60 = LatLng(42.382014, -72.528897); // John Q Adams Tower – East Side
  static const LatLng helpline61 = LatLng(42.381636, -72.528923); // John Q Adams Tower – West Side
  static const LatLng helpline62 = LatLng(42.3955609, -72.5270909); // Johnson House
  static const LatLng helpline63 = LatLng(42.3840782, -72.5322115); // Kennedy Tower
  static const LatLng helpline64 = LatLng(42.3937843, -72.5282655); // Knowlton House
  static const LatLng helpline65 = LatLng(42.3951734, -72.5283311); // Leach House
  static const LatLng helpline66 = LatLng(42.3951096, -72.5265239); // Lewis House
  static const LatLng helpline67 = LatLng(42.392755, -72.524125); // Life Science Lab – East Side
  static const LatLng helpline68 = LatLng(42.391393, -72.523295); // Life Science Lab – West Side
  static const LatLng helpline69 = LatLng(42.3870226, -72.5334561); // Linden
  static const LatLng helpline70 = LatLng(42.3804494, -72.5353179); // Lot 22 East Side – University Dr.
  static const LatLng helpline71 = LatLng(42.3989473, -72.5270459); // Lot 44 – South of Cashin
  static const LatLng helpline72 = LatLng(42.394939, -72.520508); // Lot 44 to Lot 49 Pathway
  static const LatLng helpline73 = LatLng(42.3991727, -72.5296641); // Lot 66 – North Side of Furcolo
  static const LatLng helpline74 = LatLng(42.3855449, -72.5292336); // Lot 71 – Entrance to Whitmore
  static const LatLng helpline75 = LatLng(42.382548, -72.5312017); // Mackimmie House – Front (East Side)
  static const LatLng helpline76 = LatLng(42.382570, -72.529075); // Mackimmie House – Rear (West Side)
  static const LatLng helpline77 = LatLng(42.3865975, -72.5268119); // Mahar Auditorium
  static const LatLng helpline78 = LatLng(42.3875513, -72.5335576); // Maple
  static const LatLng helpline79 = LatLng(42.3941624, -72.5270719); // Mary Lyon House
  static const LatLng helpline80 = LatLng(42.3947356, -72.5140972); // Mather Admissions Building
  static const LatLng helpline81 = LatLng(42.3793124, -72.5383609); // McGuirk Stadium – Lot 11
  static const LatLng helpline82 = LatLng(42.398347, -72.523130); // McNamara – On Path to Lot 44
  static const LatLng helpline83 = LatLng(42.3979153, -72.5236711); // McNamara House
  static const LatLng helpline84 = LatLng(42.387815, -72.526936); // Memorial Hall/Herter – On Pathway Between
  static const LatLng helpline85 = LatLng(42.384711, -72.5333494); // Melville House
  static const LatLng helpline86 = LatLng(42.3820512, -72.5333725); // Moore House
  static const LatLng helpline87 = LatLng(42.3898044, -72.5273291); // Morrill – Between IV &II
  static const LatLng helpline88 = LatLng(42.390008, -72.533758); // Mullins Center – Northwest Team Entrance
  static const LatLng helpline89 = LatLng(42.388718, -72.533102); // Mullins Center – Southwest Media Entrance
  static const LatLng helpline90 = LatLng(42.390463, -72.5364027); // Mullins Practice Rink – Southeast Side
  static const LatLng helpline91 = LatLng(42.397496, -72.5266631); // North A
  static const LatLng helpline92 = LatLng(42.3967237, -72.526758); // North B
  static const LatLng helpline93 = LatLng(42.3976485, -72.5276753); // North C
  static const LatLng helpline94 = LatLng(42.3968141, -72.5277259); // North D
  static const LatLng helpline95 = LatLng(42.39346, -72.5302499); // North Pleasant St. Bus Stop
  static const LatLng helpline96 = LatLng(42.3873358, -72.5327575); // Oak
  static const LatLng helpline97 = LatLng(42.3940649, -72.5241485); // Observatory
  static const LatLng helpline98 = LatLng(42.3950775, -72.5163369); // Olympia Drive – Lot 13
  static const LatLng helpline99 = LatLng(42.3903667, -72.5218096); // Orchard Hill Dr
  static const LatLng helpline100 = LatLng(42.3929109, -72.5228112); // Orchard Hill – Lot 49
  static const LatLng helpline101 = LatLng(42.3817924, -72.5293965); // Patterson House – Front (East Side)
  static const LatLng helpline102 = LatLng(42.381342, -72.528328); // Patterson House – Rear (West Side)
  static const LatLng helpline103 = LatLng(42.3814007, -72.5333825); // Pierpont House
  static const LatLng helpline104 = LatLng(42.3840663, -72.5315037); // Prince House
  static const LatLng helpline105 = LatLng(42.389183, -72.532211); // Rec Center East
  static const LatLng helpline106 = LatLng(42.388406, -72.531876); // Rec Center West
  static const LatLng helpline107 = LatLng(42.3850288, -72.5264573); // Robsham Visitors’ Center
  static const LatLng helpline108 = LatLng(42.3893646, -72.5324199); // South College
  static const LatLng helpline109 = LatLng(42.391832, -72.524798); // Skinner Hall East
  static const LatLng helpline110 = LatLng(42.391311, -72.524647); // Skinner Hall West
  static const LatLng helpline111 = LatLng(42.3553205, -72.6591414); // Student Union – Southwest Corner
  static const LatLng helpline112 = LatLng(42.3843426, -72.5328205); // Thoreau House
  static const LatLng helpline113 = LatLng(42.3967484, -72.5297223); // Totman – Lot 27
  static const LatLng helpline114 = LatLng(42.3774694, -72.5343655); // University Drive – Bike Path near Dallas Mall
  static const LatLng helpline115 = LatLng(42.384017, -72.531865); // University Drive – Bike Path near James
  static const LatLng helpline116 = LatLng(42.389330, -72.518124); // Van Meter House – East Side
  static const LatLng helpline117 = LatLng(42.390379, -72.518504); // Van Meter House – West Side
  static const LatLng helpline118 = LatLng(42.3815742, -72.5319432); // Washington Tower
  static const LatLng helpline119 = LatLng(42.3915267, -72.5220457); // Webster House
  static const LatLng helpline120 = LatLng(42.3886948, -72.5220121); // Wheeler House – East
  static const LatLng helpline121 = LatLng(42.389207, -72.521356); // Wheeler House – West
  static const LatLng helpline122 = LatLng(42.3861466, -72.5274466); // Whitmore – East Side Main Entrance
  static const LatLng helpline123 = LatLng(42.3902954, -72.5263111); // Wilder – East Side
  static const LatLng helpline124 = LatLng(42.3906977, -72.5202421); // Windmill Lane - North Side
  static const LatLng helpline125 = LatLng(42.3935899, -72.526872); // Worcester DC ATM

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
            children: [

              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: currentLocation == null ?
                Center(child: Text("Loading..."),)
                    :
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
                      zoom: 15
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                    print("Map Controller created");
                  },
                  markers: {
                    Marker(
                      markerId: MarkerId("CurrentLocation"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
                    ),

                    //helpline markers
                    Marker(
                      markerId: MarkerId("358 N Pleasant St."),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline1,
                    ),

                    Marker(
                      markerId: MarkerId("Baker House"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline2,
                    ),

                    Marker(
                      markerId: MarkerId("Bartlett – West Side"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline3,
                    ),

                    Marker(
                      markerId: MarkerId("Berkshire DC – South Side- Malcom X"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline4,
                    ),

                    Marker(
                      markerId: MarkerId("Berkshire House – South Side"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline5,
                    ),

                    Marker(
                      markerId: MarkerId("Birch"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline6,
                    ),

                    Marker(
                      markerId: MarkerId("Boyden Field – Tunnel Entrance"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline7,
                    ),

                    Marker(
                      markerId: MarkerId("Brett House"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline8,
                    ),

                    Marker(
                      markerId: MarkerId("Brooks House"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline9,
                    ),

                    Marker(
                      markerId: MarkerId("Brown House"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline10,
                    ),

                    Marker(
                      markerId: MarkerId("Burma Trail – Orchard Hill"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline11,
                    ),

                    Marker(
                      markerId: MarkerId("Bus Shelter B – Stadium Rd."),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline12,
                    ),

                    Marker(
                      markerId: MarkerId("Bus Shelter C – Olympia Dr."),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline13,
                    ),

                    Marker(
                      markerId: MarkerId("Bus Shelter D – Lot 12 behind Parking Services"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline14,
                    ),

                    Marker(
                      markerId: MarkerId("Bus Shelter E – Mass Ave / Sunset"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline15,
                    ),

                    Marker(
                      markerId: MarkerId("Butterfield House"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline16,
                    ),

                    Marker(
                      markerId: MarkerId("Campus Center Parking Garage – Loading Dock"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline17,
                    ),

                    Marker(
                      markerId: MarkerId("Campus Pond – West Side"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline18,
                    ),

                    Marker(
                      markerId: MarkerId("Cance House – Front (North Side)"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline19,
                    ),

                    Marker(
                      markerId: MarkerId("Cashin House"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline20,
                    ),

                    Marker(
                      markerId: MarkerId("Chadbourne House"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline21,
                    ),

                    Marker(
                      markerId: MarkerId("Champions Center S. West – Back Door"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline22,
                    ),

                    Marker(
                      markerId: MarkerId("Chenoweth"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline23,
                    ),

                    Marker(
                      markerId: MarkerId("Computer Science – North Entrance"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline24,
                    ),

                    Marker(
                      markerId: MarkerId("Computer Science – Southwest Corner"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline25,
                    ),

                    Marker(
                      markerId: MarkerId("Conte Loading Dock"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline26,
                    ),

                    Marker(
                      markerId: MarkerId("Coolidge Tower"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline27,
                    ),

                    Marker(
                      markerId: MarkerId("Crabtree House"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline28,
                    ),

                    Marker(
                      markerId: MarkerId("Crampton House"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline29,
                    ),

                    Marker(
                      markerId: MarkerId("Curry Hicks"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline30,
                    ),

                    Marker(
                      markerId: MarkerId("Dickinson House"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline31,
                    ),

                    Marker(
                      markerId: MarkerId("Draper Annex – East Side"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline32,
                    ),

                    Marker(
                      markerId: MarkerId("Durfee – North Side"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline33,
                    ),

                    Marker(
                      markerId: MarkerId("Dwight House"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline34,
                    ),

                    Marker(
                      markerId: MarkerId("ELAB II – North End"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline35,
                    ),

                    Marker(
                      markerId: MarkerId("ELAB II – South End"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline36,
                    ),

                    Marker(
                      markerId: MarkerId("Elm East"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline37,
                    ),

                    Marker(
                      markerId: MarkerId("Elm West"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline38,
                    ),

                    Marker(
                      markerId: MarkerId("Emerson House"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline39,
                    ),

                    Marker(
                      markerId: MarkerId("Field House"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline40,
                    ),

                    Marker(
                      markerId: MarkerId("Franklin DC ATM"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline41,
                    ),

                    Marker(
                      markerId: MarkerId("Furcolo"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline42,
                    ),

                    Marker(
                      markerId: MarkerId("Gordon Hall"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline43,
                    ),

                    Marker(
                      markerId: MarkerId("Goodell – Upper Entrance"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline44,
                    ),

                    Marker(
                      markerId: MarkerId("Gorman House"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline45,
                    ),

                    Marker(
                      markerId: MarkerId("Grayson House"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline46,
                    ),

                    Marker(
                      markerId: MarkerId("Greenough House"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline47,
                    ),

                    Marker(
                      markerId: MarkerId("Hampshire DC ATM"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline48,
                    ),

                    Marker(
                      markerId: MarkerId("Hamlin House"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline49,
                    ),

                    Marker(
                      markerId: MarkerId("Health Services – Main Entrance"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline50,
                    ),

                    Marker(
                      markerId: MarkerId("Herter – Haigis Mall @ Bus Stop"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline51,
                    ),

                    Marker(
                      markerId: MarkerId("ILC East – Second Floor"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline52,
                    ),

                    Marker(
                      markerId: MarkerId("ILC North – First Floor"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline53,
                    ),

                    Marker(
                      markerId: MarkerId("ILC West – Second Floor"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline54,
                    ),

                    Marker(
                      markerId: MarkerId("ISB East"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline55,
                    ),

                    Marker(
                      markerId: MarkerId("ISB East – Second Floor"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline56,
                    ),

                    Marker(
                      markerId: MarkerId("ISB West"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline57,
                    ),

                    Marker(
                      markerId: MarkerId("James House"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline58,
                    ),

                    Marker(
                      markerId: MarkerId("John Adams Tower"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline59,
                    ),

                    Marker(
                      markerId: MarkerId("John Q Adams Tower – East Side"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline60,
                    ),

                    Marker(
                      markerId: MarkerId("John Q Adams Tower – West Side"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline61,
                    ),

                    Marker(
                      markerId: MarkerId("Johnson House"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline62,
                    ),

                    Marker(
                      markerId: MarkerId("Kennedy Tower"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline63,
                    ),

                    Marker(
                      markerId: MarkerId("Knowlton House"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline64,
                    ),

                    Marker(
                      markerId: MarkerId("Leach House"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline65,
                    ),

                    Marker(
                      markerId: MarkerId("Lewis House"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline66,
                    ),

                    Marker(
                      markerId: MarkerId("Life Science Lab – East Side"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline67,
                    ),

                    Marker(
                      markerId: MarkerId("Life Science Lab – West Side"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline68,
                    ),

                    Marker(
                      markerId: MarkerId("Linden"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline69,
                    ),

                    Marker(
                      markerId: MarkerId("Lot 22 East Side – University Dr."),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline70,
                    ),

                    Marker(
                      markerId: MarkerId("Lot 44 – South of Cashin"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline71,
                    ),

                    Marker(
                      markerId: MarkerId("Lot 44 to Lot 49 Pathway"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline72,
                    ),

                    Marker(
                      markerId: MarkerId("Lot 66 – North Side of Furcolo"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline73,
                    ),

                    Marker(
                      markerId: MarkerId("Lot 71 – Entrance to Whitmore"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline74,
                    ),

                    Marker(
                      markerId: MarkerId("Mackimmie House – Front (East Side)"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline75,
                    ),

                    Marker(
                      markerId: MarkerId("Mackimmie House – Rear (West Side)"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline76,
                    ),

                    Marker(
                      markerId: MarkerId("Mahar Auditorium"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline77,
                    ),

                    Marker(
                      markerId: MarkerId("Maple"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline78,
                    ),

                    Marker(
                      markerId: MarkerId("Mary Lyon House"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline79,
                    ),

                    Marker(
                      markerId: MarkerId("Mather Admissions Building"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline80,
                    ),

                    Marker(
                      markerId: MarkerId("McGuirk Stadium – Lot 11"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline81,
                    ),

                    Marker(
                      markerId: MarkerId("McNamara – On Path to Lot 44"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline82,
                    ),

                    Marker(
                      markerId: MarkerId("McNamara House"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline83,
                    ),

                    Marker(
                      markerId: MarkerId("Memorial Hall/Herter – On Pathway Between"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline84,
                    ),

                    Marker(
                      markerId: MarkerId("Melville House"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline85,
                    ),

                    Marker(
                      markerId: MarkerId("Moore House"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline86,
                    ),

                    Marker(
                      markerId: MarkerId("Morrill – Between IV &II"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline87,
                    ),

                    Marker(
                      markerId: MarkerId("Mullins Center – Northwest Team Entrance"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline88,
                    ),

                    Marker(
                      markerId: MarkerId("Mullins Center – Southwest Media Entrance"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline89,
                    ),

                    Marker(
                      markerId: MarkerId("Mullins Practice Rink – Southeast Side"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline90,
                    ),

                    Marker(
                      markerId: MarkerId("North A"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline91,
                    ),

                    Marker(
                      markerId: MarkerId("North B"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline92,
                    ),

                    Marker(
                      markerId: MarkerId("North C"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline93,
                    ),

                    Marker(
                      markerId: MarkerId("North D"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline94,
                    ),

                    Marker(
                      markerId: MarkerId("North Pleasant St. Bus Stop"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline95,
                    ),

                    Marker(
                      markerId: MarkerId("Oak"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline96,
                    ),

                    Marker(
                      markerId: MarkerId("Observatory"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline97,
                    ),

                    Marker(
                      markerId: MarkerId("Olympia Drive – Lot 13"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline98,
                    ),

                    Marker(
                      markerId: MarkerId("Orchard Hill Dr"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline99,
                    ),

                    Marker(
                      markerId: MarkerId("Orchard Hill – Lot 49"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline100,
                    ),

                    Marker(
                      markerId: MarkerId("Patterson House – Front (East Side)"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline101,
                    ),

                    Marker(
                      markerId: MarkerId("Patterson House – Rear (West Side)"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline102,
                    ),

                    Marker(
                      markerId: MarkerId("Pierpont House"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline103,
                    ),

                    Marker(
                      markerId: MarkerId("Prince House"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline104,
                    ),

                    Marker(
                      markerId: MarkerId("Rec Center East"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline105,
                    ),

                    Marker(
                      markerId: MarkerId("Rec Center West"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline106,
                    ),

                    Marker(
                      markerId: MarkerId("Robsham Visitors' Center"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline107,
                    ),

                    Marker(
                      markerId: MarkerId("South College"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline108,
                    ),

                    Marker(
                      markerId: MarkerId("Skinner Hall East"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline109,
                    ),

                    Marker(
                      markerId: MarkerId("Skinner Hall West"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline110,
                    ),

                    Marker(
                      markerId: MarkerId("Student Union – Southwest Corner"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline111,
                    ),

                    Marker(
                      markerId: MarkerId("Thoreau House"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline112,
                    ),

                    Marker(
                      markerId: MarkerId("Totman – Lot 27"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline113,
                    ),

                    Marker(
                      markerId: MarkerId("University Drive – Bike Path near Dallas Mall"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline114,
                    ),

                    Marker(
                      markerId: MarkerId("University Drive – Bike Path near James"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline115,
                    ),

                    Marker(
                      markerId: MarkerId("Van Meter House – East Side"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline116,
                    ),

                    Marker(
                      markerId: MarkerId("Van Meter House – West Side"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline117,
                    ),

                    Marker(
                      markerId: MarkerId("Washington Tower"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline118,
                    ),

                    Marker(
                      markerId: MarkerId("Webster House"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline119,
                    ),

                    Marker(
                      markerId: MarkerId("Wheeler House – East"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline120,
                    ),

                    Marker(
                      markerId: MarkerId("Wheeler House – West"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline121,
                    ),

                    Marker(
                      markerId: MarkerId("Whitmore – East Side Main Entrance"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline122,
                    ),

                    Marker(
                      markerId: MarkerId("Wilder – East Side"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline123,
                    ),

                    Marker(
                      markerId: MarkerId("Windmill Lane - North Side"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline124,
                    ),

                    Marker(
                      markerId: MarkerId("Worcester DC ATM"),
                      icon: customIcon ?? BitmapDescriptor.defaultMarker,
                      position: helpline125,
                    ),

                    //////////
                    if (destinationMarker != null) destinationMarker!,
                    /////////

                  },
                  polylines: _polylines,
                ),
              ),
              // Search bar at the top with padding
              Positioned(
                top: MediaQuery.of(context).padding.top + 30,
                left: 16,
                right: 16,
                child: Column(
                  children: [
                    Container(
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
                        controller: _searchController,
                        onChanged: _getPlaceSuggestions,
                        style: TextStyle(
                          fontFamily: "Adam",
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                          color: Colors.black
                        ),
                        decoration: InputDecoration(
                          hintText: 'Where do you want to go?',
                          hintStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Adam',
                            color: Colors.black54
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
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_searchController.text.isNotEmpty)
                                IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      destinationMarker = null;
                                      _polylines.clear();
                                      _suggestions = [];
                                      _showSuggestions = false;
                                    });
                                  },
                                ),
                              Builder(
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (_showSuggestions && _suggestions.isNotEmpty)
                      Container(
                        margin: EdgeInsets.only(top: 2),
                        constraints: BoxConstraints(maxHeight: 200),
                        decoration: BoxDecoration(
                          color: HexColor("B7A3A3").withOpacity(0.9),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: _suggestions.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    _suggestions[index].description,
                                    style: TextStyle(
                                      fontFamily: 'Adam',
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  // Add hover effect
                                  hoverColor: HexColor("E3ADAD"),
                                  // Add subtle divider between items
                                  onTap: () {
                                    _handleSuggestionTap(_suggestions[index]);
                                  },
                                ),
                                if (index < _suggestions.length - 1)
                                  Divider(
                                    height: 1,
                                    color: Colors.black.withOpacity(0.1),
                                    indent: 16,
                                    endIndent: 16,
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                  ],
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


                      await telephonySMS.requestPermission();
                      await telephonySMS.sendSMS(phone: contact1!, message: "SOS");
                      await call('911');


                      await telephonySMS.sendSMS(phone: contact2!, message: "SOS");
                      await telephonySMS.sendSMS(phone: contact3!, message: "SOS");

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

  Future<void> searchPlace(String query) async {
    if (currentLocation == null) return;

    try {
      final String googleApiKey = API;
      final String baseUrl = 'https://maps.googleapis.com/maps/api/place/textsearch/json';
      final response = await http.get(
          Uri.parse('$baseUrl?query=$query&location=${currentLocation!.latitude},${currentLocation!.longitude}&radius=5000&key=$googleApiKey')
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          final place = data['results'][0];
          final lat = place['geometry']['location']['lat'];
          final lng = place['geometry']['location']['lng'];

          setState(() {
            destinationMarker = Marker(
              markerId: MarkerId('destination'),
              position: LatLng(lat, lng),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
              infoWindow: InfoWindow(title: place['name']),
            );
          });

          // Draw route
          await getDirections(LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
              LatLng(lat, lng));

          // Move camera to show both points
          LatLngBounds bounds = LatLngBounds(
            southwest: LatLng(
              min(currentLocation!.latitude!, lat),
              min(currentLocation!.longitude!, lng),
            ),
            northeast: LatLng(
              max(currentLocation!.latitude!, lat),
              max(currentLocation!.longitude!, lng),
            ),
          );

          mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
        }
      }
    } catch (e) {
      print('Error searching place: $e');
    }
  }

  Future<void> getDirections(LatLng origin, LatLng destination) async {
    try {
      final String googleApiKey = API;
      final String baseUrl = 'https://maps.googleapis.com/maps/api/directions/json';
      final response = await http.get(
          Uri.parse('$baseUrl?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&mode=walking&key=$googleApiKey')
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final points = decodePolyline(data['routes'][0]['overview_polyline']['points']);

          setState(() {
            _polylines.clear();
            _polylines.add(
              Polyline(
                polylineId: PolylineId('route'),
                points: points,
                color: Colors.blue,
                width: 5,
              ),
            );
          });
        }
      }
    } catch (e) {
      print('Error getting directions: $e');
    }
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  Future<void> _getPlaceSuggestions(String input) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (input.isEmpty) {
        setState(() {
          _suggestions = [];
          _showSuggestions = false;
        });
        return;
      }

      try {
        final String googleApiKey = API;
        final String baseUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
        final response = await http.get(
            Uri.parse('$baseUrl?input=$input&key=$googleApiKey&location=${currentLocation!.latitude},${currentLocation!.longitude}&radius=5000&components=country:us')
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['predictions'] != null) {
            setState(() {
              _suggestions = (data['predictions'] as List)
                  .map((prediction) => PlaceSuggestion(
                placeId: prediction['place_id'],
                description: prediction['description'],
              ))
                  .toList();
              _showSuggestions = true;
            });
          }
        }
      } catch (e) {
        print('Error getting place suggestions: $e');
      }
    });
  }

  Future<void> _handleSuggestionTap(PlaceSuggestion suggestion) async {
    try {
      final String googleApiKey = API;
      final String baseUrl = 'https://maps.googleapis.com/maps/api/place/details/json';
      final response = await http.get(
          Uri.parse('$baseUrl?place_id=${suggestion.placeId}&key=$googleApiKey')
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['result'] != null) {
          final location = data['result']['geometry']['location'];
          final lat = location['lat'];
          final lng = location['lng'];

          setState(() {
            _searchController.text = suggestion.description;
            _showSuggestions = false;
            destinationMarker = Marker(
              markerId: MarkerId('destination'),
              position: LatLng(lat, lng),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
              infoWindow: InfoWindow(title: suggestion.description),
            );
          });

          // Draw route
          await getDirections(
              LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
              LatLng(lat, lng)
          );

          // Move camera to show both points
          LatLngBounds bounds = LatLngBounds(
            southwest: LatLng(
              min(currentLocation!.latitude!, lat),
              min(currentLocation!.longitude!, lng),
            ),
            northeast: LatLng(
              max(currentLocation!.latitude!, lat),
              max(currentLocation!.longitude!, lng),
            ),
          );

          mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
        }
      }
    } catch (e) {
      print('Error handling suggestion tap: $e');
    }
  }
}

class PlaceSuggestion {
  final String placeId;
  final String description;

  PlaceSuggestion({required this.placeId, required this.description});
}