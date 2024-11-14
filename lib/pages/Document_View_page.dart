import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf_reader/Provider/Documet_view_provider.dart';
import 'package:pdf_reader/Provider/Storage_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DocumentViewPage extends StatefulWidget {
  const DocumentViewPage({super.key});

  @override
  State<DocumentViewPage> createState() => _DocumentViewPageState();
}

class _DocumentViewPageState extends State<DocumentViewPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<DocumetViewProvider, StorageProvider>(
      builder: (context, documetViewProvider, storageProvider, child) {
        searchedpage() {
          return Container(
            alignment: Alignment.bottomCenter,
            height: 90,
            color: Colors.amber,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: IconButton(
                      onPressed: () {
                        documetViewProvider.searched = false;
                        documetViewProvider.searchTextController.clear();
                        setState(() {});
                      },
                      icon: const Icon(Icons.keyboard_backspace)),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 5),
                  child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Form(
                          key: documetViewProvider.formKey,
                          child: TextFormField(
                            validator: (value) {
                              documetViewProvider.pdfViewerController
                                  .searchText(documetViewProvider
                                      .searchTextController.text);
                              setState(() {});
                              return null;
                            },
                            controller:
                                documetViewProvider.searchTextController,
                            decoration: const InputDecoration(
                                hintText: "search", border: InputBorder.none),
                          ),
                        ),
                      )),
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        onPressed: () {
                          documetViewProvider.pdfViewerController
                              .previousPage();
                        },
                        icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                    IconButton(
                        onPressed: () {
                          documetViewProvider.pdfViewerController.nextPage();
                        },
                        icon: const Icon(Icons.arrow_forward_ios_rounded))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                      onPressed: () {
                        documetViewProvider.pdfViewerController.searchText(
                            documetViewProvider.searchTextController.text);
                        setState(() {});
                        // documetViewProvider.pdfViewerController.
                      },
                      icon: const Icon(Icons.search)),
                )
              ],
            ),
          );
        }

        notsearched(context) {
          return Container(
            alignment: Alignment.bottomCenter,
            height: 90,
            color: Colors.amber,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: IconButton(
                          onPressed: () {
                            documetViewProvider.searched = false;
                            if (MediaQuery.of(context).orientation ==
                                Orientation.landscape) {
                              SystemChrome.setPreferredOrientations(
                                  [DeviceOrientation.portraitUp]);
                            }
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.keyboard_backspace_rounded)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: SizedBox(
                        width: 220,
                        child: Text(
                          documetViewProvider.selectedFile
                              .split("/")
                              .last
                              .toString(),
                          style: GoogleFonts.poppins(fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton(
                          onPressed: () {
                            documetViewProvider.searched = true;
                            setState(() {});
                          },
                          icon: const Icon(Icons.search)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton(
                          onPressed: () {
                            if (MediaQuery.of(context).orientation ==
                                Orientation.portrait) {
                              SystemChrome.setPreferredOrientations(
                                  [DeviceOrientation.landscapeLeft]);
                            } else {
                              SystemChrome.setPreferredOrientations(
                                  [DeviceOrientation.portraitUp]);
                            }
                          },
                          icon: const Icon(Icons.screen_rotation_rounded)),
                    ),
                  ],
                )
              ],
            ),
          );
        }

        return Scaffold(
          body: Column(
            children: [
              documetViewProvider.searched
                  ? searchedpage()
                  : notsearched(context),
              Expanded(
                child: Container(
                    child: SfPdfViewer.file(
                        canShowScrollHead: true,
                        enableDoubleTapZooming: true,
                        initialPageNumber:
                            documetViewProvider.pdfViewerController.pageCount,
                        controller: documetViewProvider.pdfViewerController,
                        enableHyperlinkNavigation: true,
                        enableTextSelection: true,
                        canShowTextSelectionMenu: true,
                        canShowScrollStatus: true,
                        currentSearchTextHighlightColor: Colors.deepOrange,
                        File(documetViewProvider.selectedFile))),
              ),
            ],
          ),
        );
      },
    );
  }
}
