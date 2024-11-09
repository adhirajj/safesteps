import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  static const LatLng _pGooglePlex = LatLng(37.4223, -122.0848);
  late GoogleMapController mapController;

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
                      suffixIcon: Container(
                        padding: const EdgeInsets.all(10),
                        child: const Icon(
                          Icons.settings,
                          color: Colors.black,
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
    );
  }
}
