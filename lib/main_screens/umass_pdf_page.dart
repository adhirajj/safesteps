import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:pdfx/pdfx.dart';

class PdfViewerPage extends StatelessWidget {
  const PdfViewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pdfController = PdfControllerPinch(
      document: PdfDocument.openAsset('lib/main_screens/pdf/Help_Phones_locations.pdf'),
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: HexColor('E3ADAD').withOpacity(0.9),
        title: const Text('UMass Help Phones Map'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
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
        child: PdfViewPinch(
          controller: pdfController,
        ),
      ),
    );
  }
}