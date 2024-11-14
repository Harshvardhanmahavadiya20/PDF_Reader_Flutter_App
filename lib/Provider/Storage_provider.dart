import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageProvider extends ChangeNotifier {
  Directory directory = Directory('/storage/emulated/0');
  List<String> pdfFiles = [];
  List<String> recentFiles = [];
  bool recentfilesCheck = false;
    sharefile(int index) {
          var file = pdfFiles[index];
          print("DASDASDASD: $file");
          Share.shareXFiles([XFile(file)], text: "Here's your PDF file!");
        }

  getRecentList() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var RecentList = sharedPreferences.getStringList('recentpdfs');
    for (var pf in RecentList!) {
      // print("CHECKEDDDDDDDDDDDDDDDDDDDDDD: $pf");
      if (!recentFiles.contains(pf)) {
        recentFiles.add(pf);
      }
    }
    print("GETED FILES: $recentFiles");
  }

  saveRecentList() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setStringList('recentpdfs', recentFiles);
    print("DONNNNNNNNNNNNNNNNNNNNNNNEEEEEEEEEEEEEEEEEEEEEEEEEEEE");
  }

  Future getdir() async {
    directory.list(recursive: true).listen((FileSystemEntity entity) {
      if (entity is File && entity.path.endsWith('.pdf')) {
        // print('PDF File: ${entity.path}');
        if (pdfFiles.contains(entity.path)) {
        } else {
          pdfFiles.add(entity.path);
          // print('PDF File ADDED: $pdfFiles');
        }
        notifyListeners();
      }
    });
    notifyListeners();
  }

  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.request().isGranted) {
        print("Manage external storage permission granted");
        await getdir();
        await getRecentList();
      } else {
        print("Manage external storage permission denied");
        await openAppSettings(); // Guide the user to settings
      }
    } else {
      if (await Permission.storage.request().isGranted) {
        print("Storage permission granted");
      } else {
        print("Storage permission denied");
      }
    }
    notifyListeners();
  }
}
