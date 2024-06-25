import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class AltitudeService {
  //Atmospheric pressure at sea level in hPa
  static const double seaLevelPressure = 1013.25;

  //Shared Preferences keys used for highest/lowest achieved altitude
  static const String _keyHighestAltitude = 'highest_altitude';
  static const String _keyLowestAltitude = 'lowest_altitude';

  //List of landmarks and locations
  static List<Map<String, dynamic>> landmarks = [
    {"name": "Amsterdam, Netherlands", "altitude": -2},
    {"name": "Venice, Italy", "altitude": 0},
    {"name": "Bangkok, Thailand", "altitude": 1.5},
    {"name": "Washington, D.C., USA", "altitude": 2},
    {"name": "New York City, USA", "altitude": 10},
    {"name": "London, UK", "altitude": 11},
    {"name": "Cape Town, South Africa", "altitude": 15},
    {"name": "San Francisco, USA", "altitude": 16},
    {"name": "Rome, Italy", "altitude": 21},
    {"name": "Cairo, Egypt", "altitude": 23},
    {"name": "Paris, France", "altitude": 35},
    {"name": "Istanbul, Turkey", "altitude": 39},
    {"name": "Tokyo, Japan", "altitude": 40},
    {"name": "Beijing, China", "altitude": 44},
    {"name": "Sydney, Australia", "altitude": 58},
    {"name": "Innsbruck, Austria", "altitude": 577},
    {"name": "Asheville, North Carolina, USA", "altitude": 661},
    {"name": "Madrid, Spain", "altitude": 667},
    {"name": "Queenstown, New Zealand", "altitude": 310},
    {"name": "Athens, Greece", "altitude": 70},
    {"name": "Medellín, Colombia", "altitude": 1495},
    {"name": "Medellín, Colombia", "altitude": 1495},
    {"name": "Zermatt, Switzerland", "altitude": 1620},
    {"name": "Nairobi, Kenya", "altitude": 1795},
    {"name": "Mexico City, Mexico", "altitude": 2250},
    {"name": "Addis Ababa, Ethiopia", "altitude": 2355},
    {"name": "Quito, Ecuador", "altitude": 2850},
    {"name": "Cuzco, Peru", "altitude": 3400},
    {"name": "Leh, India", "altitude": 3524},
    {"name": "La Paz, Bolivia", "altitude": 3640},
    {"name": "Lhasa, Tibet", "altitude": 3656},
    {"name": "Lake Titicaca, Peru/Bolivia", "altitude": 3812},
    {"name": "Potosí, Bolivia", "altitude": 4090},
    {"name": "Mount Everest Base Camp, Nepal/Tibet", "altitude": 5364},
    {"name": "Mount Kilimanjaro, Tanzania", "altitude": 5895},
    {"name": "Mount McKinley (Denali), Alaska, USA", "altitude": 6190},
    {"name": "Aconcagua, Argentina", "altitude": 6960},
    {"name": "K2, Pakistan/China", "altitude": 8611},
    {"name": "Mount Everest, Nepal/China", "altitude": 8848}
  ];

  // Method to calculate altitude based on atmospheric pressure
  static int calculateAltitude(double pressure) {
    // Formula used:
    // h=44330.0×(1−(P/Po)^0.1903)
    // h = height in meters
    // P = atmospheric pressure in hPa
    // Po = atmospheric pressure at sea level in hPa
    double rawAltitude = 44330.0 * (1.0 - pow((pressure / seaLevelPressure), 0.1903));
    return rawAltitude.round();
  }

  static String altitudeText(int approxAltitude) {
    updateHighScores(approxAltitude);
    if (approxAltitude > 1000) {
      double altitudeKm = approxAltitude / 1000;
      return "${altitudeKm.toStringAsFixed(2)} Km";
    } else {
      return "$approxAltitude meters";
    }
  }

  //Method to get closest landmark and show it to user
  static String showLandmark(int approxAltitude) {
    Map<String, dynamic> closest = landmarks.first;
    num minDiff = (approxAltitude - closest["altitude"]).abs();

    for (var landmark in landmarks) {
      num diff = (approxAltitude - landmark["altitude"]).abs();
      if (diff < minDiff) {
        closest = landmark;
        minDiff = diff;
      }
    }

    return closest["name"];
  }

  // Method to fetch highest and lowest altitudes from SharedPreferences
  static Future<Map<String, int>> fetchHighScores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int highestAltitude = prefs.getInt(_keyHighestAltitude) ?? 0;
    int lowestAltitude = prefs.getInt(_keyLowestAltitude) ?? 0;

    return {'highest': highestAltitude, 'lowest': lowestAltitude};
  }

  // Method to set highest and lowest altitudes from SharedPreferences
  static Future<void> updateHighScores(int newAltitude) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, int> highScores = await fetchHighScores();

    if (newAltitude > highScores['highest']!) {
      await prefs.setInt(_keyHighestAltitude, newAltitude);
    }

    if (newAltitude < highScores['lowest']! || highScores['lowest'] == 0) {
      await prefs.setInt(_keyLowestAltitude, newAltitude);
    }
  }
}
