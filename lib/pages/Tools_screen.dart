import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/material.dart';

class ToolsScreen extends StatefulWidget {
  const ToolsScreen({super.key});

  @override
  State<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen> {
  // Move files list outside the build method
  List<String>? files = [];

  // Scan function to get document images
  void scandoc() async {
    try {
      List<String>? scannedFiles = await CunningDocumentScanner.getPictures(
          isGalleryImportAllowed: true);

      if (scannedFiles != null) {
        setState(() {
          files = scannedFiles; // Update the files list and refresh UI
        });
      }
    } catch (e) {
      // Handle any errors
      print("Error scanning document: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Document Scanner")),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                scandoc();
              },
              child: const Text("Scan"),
            ),
          ),
          Expanded(
            child: Container(
              height: 600,
              width: 400,
              color: Colors.amber,
              child: files != null && files!.isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: files!.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          height: 200,
                          width: 200,
                          child: Image.file(File(files![index])),
                        );
                      },
                    )
                  : const Center(child: Text("No files scanned")),
            ),
          ),
        ],
      ),
    );
  }
}
