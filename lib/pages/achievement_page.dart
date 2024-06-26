import 'package:altitude_tracker/globals.dart';
import 'package:altitude_tracker/services/altitude_service.dart';
import 'package:flutter/material.dart';


class AchievementPage extends StatefulWidget {
  const AchievementPage({super.key});

  final String title = "Achievements";

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

  //Fetches scores from shared preferences
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
          style: CustomTextStyles.labelStyleWhite(),
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

  //Widget that dictates portrait layout
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

  //Widget that dictates landscape layout
  Widget buildLandscapeView() {
    double witdthMultiplier = .45;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        highScore(witdthMultiplier),
        SizedBox(width: ScreenDimensions.width(context) * .03 ,),
        lowScore(witdthMultiplier)
      ],
    );
  }

  // Widget that displays highscore
  Widget highScore(double witdthMultiplier){
    return   CardWidget(
      titleText: "Highest Achieved Altitude:",
      infoText: "$_highestAltitude meters",
      cardWidth: ScreenDimensions.width(context) * witdthMultiplier,
      cardColor: AppColors.primaryColor,
      titleStyle: CustomTextStyles.labelStyleWhite(),
      infoStyle: CustomTextStyles.headerStyleWhite(),
    );
  }

  // Widget that displays lowscore
  Widget lowScore(double witdthMultiplier){
    return CardWidget(
      titleText: "Lowest Achieved Altitude:",
      infoText: "$_lowestAltitude meters",
      cardWidth: ScreenDimensions.width(context) * witdthMultiplier,
      cardColor: AppColors.primaryColor,
      titleStyle: CustomTextStyles.labelStyleWhite(),
      infoStyle: CustomTextStyles.headerStyleWhite(),
    );
  }
}
