import 'package:flutter/material.dart';
import 'package:pdf_reader/pages/All_files_screen.dart';
import 'package:pdf_reader/pages/Recent_screen.dart';
import 'package:pdf_reader/pages/Tools_screen.dart';

class NavigationProvider extends ChangeNotifier {
  int currentIndex = 0;
  final List<Widget> pages = [
    const AllFilesScreen(),
    const RecentScreen(),
    const ToolsScreen()
  ];
}
