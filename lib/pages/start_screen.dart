import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pdf_reader/Provider/Storage_provider.dart';
import 'package:pdf_reader/pages/Main_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  initState() {
    super.initState();
    StorageProvider().requestPermissions();
    Timer(
      const Duration(seconds: 5),
      () {
        StorageProvider().getdir();
        print("DONEEEEEEEEEEEEEEEEEEEEEEEEEEEEE");
        setState(() {});
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MainScreen()));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 300,
        color: Colors.amber,
        child: const Text("STARTING..."),
      ),
    );
  }
}
