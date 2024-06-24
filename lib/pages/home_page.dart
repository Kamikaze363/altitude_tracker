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

class _HomePageState extends State<HomePage> {
  final double customPadding = 16.0;
  String? _altitude;
  double _pressure = 0.0;

  final List<StreamSubscription<dynamic>> _streamSubscriptions = <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    super.initState();
    _initBarometer();
  }

  void _initBarometer() {
    _streamSubscriptions.add(flutterBarometerEvents.listen((FlutterBarometerEvent event) {
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
    super.dispose();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: [
              SingleCardStats(
                  headText: "Approx. Altitude:",
                  statsText: _altitude.toString(),
                  widthCard: ScreenSizes.width(context)*.9,
                  colorCard: AppColors.primaryColor,
                  titleStyle: AppStyles.labelStyleWhite(),
                  statsStyle: AppStyles.headerStyleWhite()
              ),

              const SizedBox(height: 20),

              SingleCardStats(
                  headText: "You are at about the \nsame altitude as:",
                  statsText: AltitudeService.showLandmark(AltitudeService.calculateAltitude(_pressure)),
                  widthCard: ScreenSizes.width(context)*.9,
                  colorCard: AppColors.primaryColor,
                  titleStyle: AppStyles.labelStyleWhite(),
                  statsStyle: AppStyles.labelStyleWhite()
              )
            ],
          ),
        ),
      ),
    );
  }
}
