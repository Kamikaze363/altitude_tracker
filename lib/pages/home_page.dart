import 'package:altitude_tracker/globals.dart';
import 'package:altitude_tracker/pages/profile_page.dart';
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

      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          widget.title,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.accentColor
          ),
        ),
        actions: [
          IconButton(
              tooltip: "Go to achievements",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(title: AppTitle.title),
                  ),
                );
              },
              icon: const Icon(Icons.emoji_events, color: AppColors.accentColor, size: 40,)
          )

        ],
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
        altitudeCard(witdhMultiplier),

        const SizedBox(height: 20),

        locationsCard(witdhMultiplier)
      ],
    );
  }

  Widget buildLandscapeView() {
    double witdhMultiplier = .45;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        altitudeCard(witdhMultiplier),
        SizedBox(width:ScreenSizes.width(context) * .03 ,),
        locationsCard(witdhMultiplier)
      ],
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
}
