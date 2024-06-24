import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AppColors {
  static const Color primaryColor = Color(0xFF2A5DFF);
  static const Color secondaryColor = Color(0xFF70D5FF);
  static const Color accentColor = Color(0xFFF9F6F7);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

// Add more colors as needed
}

class AppFonts {
  static final TextTheme poppins = GoogleFonts.poppinsTextTheme();
}

class AppTitle {
  static const String title = "Altitude Tracker";
}

class AppStyles {

  static TextStyle labelStyle() {
    return const TextStyle(
      // fontWeight: FontWeight.bold,
      fontSize: 20,
    );
  }

  static TextStyle headerStyle() {
    return const TextStyle(fontSize: 45);
  }
}