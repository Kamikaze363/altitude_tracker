import 'package:altitude_tracker/pages/home_page.dart';
import 'package:altitude_tracker/pages/achievement_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//used for the bottom app bar
const pages = [
  HomePage(),
  AchievementPage(),
];

int currentPageIndex = 0;

//Custom App Colors
class AppColors {
  static const Color primaryColor = Color(0xFF2A5DFF);
  static const Color accentColor = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
}

//Global font used in app
class AppFonts {
  static final TextTheme poppins = GoogleFonts.poppinsTextTheme();
}

//Title used on all screens
class AppTitle {
  static const String title = "Altitude Tracker";
}

//Custom text styles used in app
class CustomTextStyles {
  static TextStyle labelStyle() {
    return const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
    );
  }
  static TextStyle labelStyleWhite() {
    return const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: AppColors.accentColor
    );
  }
  static TextStyle headerStyle() {
    return const TextStyle(fontSize: 45);
  }
  static TextStyle headerStyleWhite() {
    return const TextStyle(fontSize: 45, color: AppColors.accentColor);
  }
}

//Used to get screen dimensions for responsive widget sizing
class ScreenDimensions {
  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}

// Custom CardWidget used throughout app
class CardWidget extends StatelessWidget {
  final String titleText;
  final String infoText;
  final double cardWidth;
  final Color cardColor;
  final TextStyle titleStyle;
  final TextStyle infoStyle;

  const CardWidget(
    {super.key,
      required this.titleText,
      required this.infoText,
      required this.cardWidth,
      required this.cardColor,
      required this.titleStyle,
      required this.infoStyle
    });

  @override
  Widget build(BuildContext context) {
    const double paddingCard = 18.0;

    return Container(
      width: cardWidth,
      // height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), color: cardColor),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(paddingCard),
            alignment: Alignment.centerLeft,
            child: Text(
              titleText,
              textAlign: TextAlign.end,
              style: titleStyle,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(paddingCard),
            alignment: Alignment.centerRight,
            child: Text(infoText, textAlign: TextAlign.start, style: infoStyle),
          )
        ],
      ),
    );
  }
}

