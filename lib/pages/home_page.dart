import 'package:altitude_tracker/globals.dart';
import 'package:altitude_tracker/services/altitude_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_barometer/flutter_barometer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final double customPadding = 16.0;
  String? _altitude;
  double _pressure = 0.0;

  final List<StreamSubscription<dynamic>> _streamSubscriptions = <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    currentPageIndex = 0;
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initBarometer();
  }

  void _initBarometer() {
    _streamSubscriptions.add(flutterBarometerEvents.listen((FlutterBarometerEvent event) {
      if (!mounted) return;
      setState(() {
        _pressure = event.pressure;
        _calculateAltitude(_pressure);
      });
    }));
  }

  void _calculateAltitude(double pressure) {
    String altitude = AltitudeService.altitudeText(AltitudeService.calculateAltitude(pressure));

    setState(() {
      _altitude = altitude;
    });
  }

  @override
  void dispose() {
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
        subscription.pause();
      }
    } else if (state == AppLifecycleState.resumed) {
      for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
        subscription.resume();
      }
    }
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
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.accentColor
          ),
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
    const double witdhMultiplier = .9;
    return Column(

      children: [
        altitudeCard(witdhMultiplier),

        const SizedBox(height: 20),

        locationsCard(witdhMultiplier)
      ],
    );
  }

  Widget buildLandscapeView() {
    const double witdhMultiplier = .45;
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              altitudeCard(witdhMultiplier),
              SizedBox(width:ScreenSizes.width(context) * .03 ,),
              locationsCard(witdhMultiplier)
            ],
          ),
          const SizedBox(height: 40),
          Text("All Landmarks and Locations:", style: AppStyles.headerStyle(),),
          buildLocationList()
        ]
      );
  }

  Widget altitudeCard(double witdhMultiplier){
    return CardWidget(
        titleText: "Approx. Altitude:",
        infoText: _altitude.toString(),
        cardWidth: ScreenSizes.width(context) * witdhMultiplier,
        cardColor: AppColors.primaryColor,
        titleStyle: AppStyles.labelStyleWhite(),
        infoStyle: AppStyles.headerStyleWhite()
    );
  }

  Widget locationsCard(double witdhMultiplier){
    return CardWidget(
        titleText: "You are at about the \nsame altitude as:",
        infoText: AltitudeService.showLandmark(AltitudeService.calculateAltitude(_pressure)),
        cardWidth: ScreenSizes.width(context) * witdhMultiplier,
        cardColor: AppColors.primaryColor,
        titleStyle: AppStyles.labelStyleWhite(),
        infoStyle: AppStyles.labelStyleWhite()
    );
  }
  Widget buildLocationList() {
    return SizedBox(
      height: 159, // Adjust the height as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: AltitudeService.landmarks.length,
        itemBuilder: (context, index) {
          var landmark = AltitudeService.landmarks[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0), // Adjust horizontal spacing between cards
            child: CardWidget(
              titleText: "${landmark['name']}",
              titleStyle: AppStyles.labelStyleWhite(), // Adjust styles as needed
              infoText: "${landmark['altitude']} meters",
              infoStyle: AppStyles.labelStyleWhite(), // Adjust styles as needed
              cardColor: AppColors.primaryColor,
              cardWidth: MediaQuery.of(context).size.width * 0.3, // Adjust width as needed
            ),
          );
        },
      ),
    );
  }
}
