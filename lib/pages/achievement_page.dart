import 'package:altitude_tracker/globals.dart';
import 'package:altitude_tracker/services/altitude_service.dart';
import 'package:flutter/material.dart';


class AchievementPage extends StatefulWidget {
  const AchievementPage({super.key, required this.title});

  final String title;

  @override
  State<AchievementPage> createState() => _AchievementPageState();
}

class _AchievementPageState extends State<AchievementPage> {
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
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => pages[currentPageIndex],
            ),
          );
        },
        indicatorColor: AppColors.primaryColor,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Home"),
          NavigationDestination(
            icon: Icon(Icons.emoji_events_outlined),
            selectedIcon: Icon(Icons.emoji_events),
            label: "Achievements"),
        ],
      ),
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return isLandscape ? buildLandscapeView() : buildPortraitView();
            },
          )
        ),
      ),
    );
  }

  Widget buildPortraitView() {
    double witdhMultiplier = .9;
    return Column(
      children: [
        highScore(witdhMultiplier),
        const SizedBox(height: 20),
        lowScore(witdhMultiplier)
      ],
    );
  }

  Widget buildLandscapeView() {
    double witdhMultiplier = .45;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        highScore(witdhMultiplier),
        SizedBox(width: ScreenSizes.width(context) * .03 ,),
        lowScore(witdhMultiplier)
      ],
    );
  }

  Widget highScore(double witdhMultiplier){
    return   CardWidget(
      titleText: "Highest Achieved Altitude:",
      infoText: "$_highestAltitude meters",
      cardWidth: ScreenSizes.width(context) * witdhMultiplier,
      cardColor: AppColors.primaryColor,
      titleStyle: AppStyles.labelStyleWhite(),
      infoStyle: AppStyles.headerStyleWhite(),
    );
  }

  Widget lowScore(double witdhMultiplier){
    return CardWidget(
      titleText: "Lowest Achieved Altitude:",
      infoText: "$_lowestAltitude meters",
      cardWidth: ScreenSizes.width(context) * witdhMultiplier,
      cardColor: AppColors.primaryColor,
      titleStyle: AppStyles.labelStyleWhite(),
      infoStyle: AppStyles.headerStyleWhite(),
    );
  }
}
