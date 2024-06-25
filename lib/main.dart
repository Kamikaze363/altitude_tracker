import 'package:altitude_tracker/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'globals.dart';

//DONE: Add responsiveness
//TODO: Clean up code
//TODO: Add login
//TODO: move locations back to JSON file
//TODO: Do an integration test
//TODO: Write documentation / paper
//TODO: Make demo video / test video

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Altitude Tracker',
      theme: ThemeData(
        textTheme: AppFonts.poppins,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
        useMaterial3: true,
      ),
      home: const HomePage(title: AppTitle.title),
    );
  }
}