import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AppColors {
  static const Color primaryColor = Color(0xFF2A5DFF);
  static const Color secondaryColor = Color(0xFF70D5FF);
  static const Color accentColor = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
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

class ScreenSizes {
  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}

class SingleCardStats extends StatelessWidget {
  final String headText;
  final String statsText;
  final double widthCard;
  final Color colorCard;
  final TextStyle titleStyle;
  final TextStyle statsStyle;

  const SingleCardStats(
      {super.key,
        required this.headText,
        required this.statsText,
        required this.widthCard,
        required this.colorCard,
        required this.titleStyle,
        required this.statsStyle
      });

  @override
  Widget build(BuildContext context) {
    const double paddingCard = 18.0;

    return Container(
      width: widthCard,
      // height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: colorCard),

      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(paddingCard),
            alignment: Alignment.centerLeft,
            child: Text(
              headText,
              textAlign: TextAlign.end,
              style: titleStyle,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(paddingCard),
            alignment: Alignment.centerRight,
            child: Text(statsText, textAlign: TextAlign.start, style: statsStyle),
          )
        ],
      ),
    );
  }
}
