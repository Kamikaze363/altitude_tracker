import 'package:altitude_tracker/globals.dart';
import 'package:altitude_tracker/services/altitude_service.dart';
import 'package:flutter/material.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.title});

  final String title;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final double customPadding = 16.0;

  int _highestAltitude = 0;
  int _lowestAltitude = 0;

  @override
  void initState() {
    super.initState();
    fetchHighScores();
  }

  Future<void> fetchHighScores() async {
    Map<String, int> highScores = await AltitudeService.fetchHighScores();
    setState(() {
      _highestAltitude = highScores['highest'] ?? 0;
      _lowestAltitude = highScores['lowest'] ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          widget.title,
          style: AppStyles.labelStyleWhite(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(customPadding),
          child: Column(
            children: [
              SingleCardStats(
            headText: "Highest Achieved Altitude:",
            statsText: "${_highestAltitude} meters",
            widthCard: ScreenSizes.width(context) * 0.9,
            colorCard: AppColors.primaryColor,
            titleStyle: AppStyles.labelStyleWhite(),
            statsStyle: AppStyles.headerStyleWhite(),
          ),
          const SizedBox(height: 20),
          SingleCardStats(
            headText: "Lowest Achieved Altitude:",
            statsText: "${_lowestAltitude} meters",
            widthCard: ScreenSizes.width(context) * 0.9,
            colorCard: AppColors.primaryColor,
            titleStyle: AppStyles.labelStyleWhite(),
            statsStyle: AppStyles.headerStyleWhite(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
