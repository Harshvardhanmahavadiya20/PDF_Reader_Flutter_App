import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf_reader/Provider/Navigation_provider.dart';
import 'package:pdf_reader/Provider/Storage_provider.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    StorageProvider().getRecentList();
    StorageProvider().requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<StorageProvider, NavigationProvider>(
      builder: (context, storageProvider, navigationProvider, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF30363d),
            title: Text(
              "PDF Reader",
              style: GoogleFonts.poppins(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    storageProvider.getRecentList();
                  },
                  icon: const Icon(
                    Icons.search,
                    size: 28,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () {
                    print("RECENT LIST: ${storageProvider.recentFiles}");
                  },
                  icon: const Icon(
                    Icons.settings,
                    size: 28,
                    color: Colors.white,
                  ))
            ],
          ),
          body: navigationProvider.pages[navigationProvider.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            showUnselectedLabels: false,
            currentIndex: navigationProvider.currentIndex,
            backgroundColor: const Color(0xFF30363d),
            unselectedItemColor: Colors.white,
            selectedItemColor: Colors.blue,
            unselectedLabelStyle: GoogleFonts.poppins(fontSize: 14),
            selectedLabelStyle: GoogleFonts.poppins(fontSize: 18),
            unselectedIconTheme: const IconThemeData(size: 26),
            selectedIconTheme: const IconThemeData(
              size: 28,
              color: Colors.blue,
            ),
            onTap: (index) {
              setState(() {
                navigationProvider.currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.description_outlined),
                label: 'Pdf Files',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.watch_later_outlined),
                label: 'Recent',
              ),
              // BottomNavigationBarItem(
              //   icon: ImageIcon(AssetImage('assets/tools.png')),
              //   label: 'Tools',
              // ),
            ],
          ),
        );
      },
    );
  }
}
