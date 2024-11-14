import 'package:flutter/material.dart';
import 'package:pdf_reader/Provider/Documet_view_provider.dart';
import 'package:pdf_reader/Provider/Navigation_provider.dart';
import 'package:pdf_reader/Provider/Storage_provider.dart';
import 'package:pdf_reader/pages/Main_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => StorageProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DocumetViewProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => NavigationProvider(),
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Simple PDF Reader',
          theme: ThemeData(
            // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            primaryColor: const Color(0xFF161b22),
            useMaterial3: true,
          ),
          home: const MainScreen()),
    );
  }
}
