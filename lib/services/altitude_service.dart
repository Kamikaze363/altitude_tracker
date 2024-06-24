import 'dart:math';

class AltitudeCalculator {
  static const double seaLevelPressure = 1013.25; // hPa

  static double calculateAltitude(double pressure) {
    // Barometric formula used:
    // h=44330×(1−(P/Pv0)^0.1903)
    return 44330.0 * (1.0 - pow((pressure / seaLevelPressure), 0.1903));
  }
}
