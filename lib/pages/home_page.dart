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

class _HomePageState extends State<HomePage> {
  final double customPadding = 16.0;

  double? _altitude;
  bool _isLoading = true;
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
    double altitude = AltitudeCalculator.calculateAltitude(pressure);

    setState(() {
      _altitude = altitude;
      _isLoading = false;
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
        backgroundColor: Colors.blue,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(customPadding),
          child: Column(
            children: [
              _isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                children: [
                  Text(
                    'Pressure: ${_pressure.toStringAsFixed(2)} hPa',
                    style: AppStyles.labelStyle(),
                  ),
                  Text(
                    'Approx. Altitude: ${_altitude?.toStringAsFixed(2)} meters',
                    style: AppStyles.labelStyle(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
