import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AppColors {
  static const Color primaryColor = Color(0xFFFFB580);
  static const Color secondaryColor = Color(0xFFFFE8D6);
  static const Color accentColor = Color(0xFFF9F6F7);
  static const Color white = Color(0xFFFFFFFF);
  static const Color blue = Color(0xFFD6E9FF);
  static const Color green = Color(0xFFD7FFD6);
  static const Color yellow = Color(0xFFF3F4BC);
  static const Color black = Color(0xFF000000);
  static const Color red = Color(0xFFc30010);
  static const Color primaryColorDark = Color(0xFF33241a);

// Add more colors as needed
}

class AppFonts {
  static final TextTheme poppins = GoogleFonts.poppinsTextTheme();
}

class AppTitle {
  static const String title = "Stop It";
}

class AppStyles {

  static TextStyle labelStyle() {
    return const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
    );
  }

  static TextStyle headerStyle() {
    return const TextStyle(fontSize: 45);
  }
}