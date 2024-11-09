import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            // This container will be replaced with Google Maps
            Container(
              color: Colors.grey[300], // Placeholder color for the map
              width: double.infinity,
              height: double.infinity,
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
            Positioned(
              bottom: 32,
              left: 16,
              right: 16,
              child: ElevatedButton(
                onPressed: () {
                  // Add your button action here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'SOS',
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
                        Icons.phone,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }
}
