import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:safesteps/main_screens/settings_page.dart';

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

      endDrawer: Drawer(
        backgroundColor: Colors.transparent,
        width: 310,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            bottomLeft: Radius.circular(40),
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
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: [
                Container(
                  height: 150,
                  child: const Center(
                    child: Text(
                      "Settings",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Adam',
                      ),
                    ),
                  ),
                ),
                Divider(color: Colors.black.withOpacity(0.8), height: 3),
                ...drawerItems.map((item) => AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        title: Text(
                          item.title,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.9),
                            fontSize: 16,
                            fontFamily: "Adam",
                            letterSpacing: -1,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            item.subTitle,
                            style: TextStyle(
                              color: HexColor('3C3333').withOpacity(0.9),
                              fontSize: 12,
                              fontFamily: "Adam",
                              letterSpacing: -1,
                            ),
                          ),
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
