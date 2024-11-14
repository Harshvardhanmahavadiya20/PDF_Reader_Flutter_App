import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf_reader/Provider/Documet_view_provider.dart';
import 'package:pdf_reader/Provider/Storage_provider.dart';
import 'package:pdf_reader/pages/Document_View_page.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class AllFilesScreen extends StatefulWidget {
  const AllFilesScreen({super.key});

  @override
  State<AllFilesScreen> createState() => _AllFilesScreenState();
}

class _AllFilesScreenState extends State<AllFilesScreen> {
  // Helper function to format file size
  String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    final i = (bytes == 0) ? 0 : (log(bytes) / log(1024)).floor();
    final size = (bytes / pow(1024, i)).toStringAsFixed(decimals);
    return "$size ${suffixes[i]}";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<StorageProvider, DocumetViewProvider>(
      builder: (context, storageProvider, documetViewProvider, child) {
        deletedialog(int index) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Text(
                "Permenently Delete ${storageProvider.pdfFiles[index].split('/').last} File  ?",
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              title: Text(
                " ${storageProvider.pdfFiles[index].split('/').last}",
                style: GoogleFonts.poppins(fontSize: 24),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancle",
                      style: GoogleFonts.poppins(),
                    )),
                TextButton(
                    onPressed: () {
                      var file = storageProvider.pdfFiles[index];

                      storageProvider.pdfFiles.remove(file);

                      if (storageProvider.recentFiles.contains(file)) {
                        storageProvider.recentFiles.remove(file);
                        storageProvider.saveRecentList();
                        setState(() {});
                      }
                      if (File(file).existsSync()) {
                        File(file).delete();
                        setState(() {});
                        print("FILE DELETED");

                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      'Remove',
                      style: GoogleFonts.poppins(),
                    ))
              ],
            ),
          );
        }

        if (storageProvider.pdfFiles.isEmpty) {
          storageProvider.getdir();
        }
        print("###########################: ${storageProvider.pdfFiles}");
        return Scaffold(
          backgroundColor: const Color(0xFF161b22),
          body: Column(
            children: [
              Expanded(
                child: storageProvider.pdfFiles.isNotEmpty
                    ? ListView.builder(
                        itemCount: storageProvider.pdfFiles.length,
                        itemBuilder: (context, index) {
                          final file = File(storageProvider.pdfFiles[index]);
                          final fileSize = file.lengthSync();
                          final formattedSize = formatBytes(fileSize, 2);

                          return Container(
                            decoration: const BoxDecoration(
                                // color: Colors.white54, .l
                                ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Container(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: const Border(
                                        bottom:
                                            BorderSide(color: Colors.black)),
                                  ),
                                  child: Center(
                                    child: InkWell(
                                      onTap: () async {
                                        documetViewProvider.selectedFile =
                                            storageProvider.pdfFiles[index];

                                        if (!storageProvider.recentFiles
                                            .contains(storageProvider
                                                .pdfFiles[index])) {
                                          storageProvider.recentFiles.add(
                                              storageProvider.pdfFiles[index]);
                                        }

                                        print(
                                            "HERE IS LIST: ${storageProvider.recentFiles}");

                                        storageProvider.saveRecentList();

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const DocumentViewPage()),
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: SizedBox(
                                              // color: Colors.red,
                                              height: 60,
                                              width: 50,
                                              child: Image.asset(
                                                'assets/pdf.png',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              SizedBox(
                                                width: 260,
                                                child: Text(
                                                  storageProvider
                                                      .pdfFiles[index]
                                                      .split('/')
                                                      .last,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 18),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Text(
                                                formattedSize,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 14),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              PopupMenuButton(
                                                onSelected: (value) {
                                                  if (value == 'delete') {
                                                    deletedialog(index);
                                                    // print("CHECKKKKKKKKKKKKKK");
                                                  } else if (value == 'share') {
                                                    storageProvider
                                                        .sharefile(index);
                                                    print("SHARE");
                                                  }
                                                },
                                                icon: SizedBox(
                                                  height: 20,
                                                  child: Image.asset(
                                                      'assets/menu.png'),
                                                ),
                                                itemBuilder: (context) => [
                                                  const PopupMenuItem(
                                                    value: 'delete',
                                                    child: Text("Delete"),
                                                  ),
                                                  const PopupMenuItem(
                                                    value: 'share',
                                                    child: Text("Share"),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
