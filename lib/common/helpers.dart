import './enums/units.dart';

import 'enums/units.dart';

class Helpers {
  static double calculateCaloriesPerMinute(
      {double mets = 1, double weight = 75, Units units = Units.Metric}) {
    return mets *
        3.5 *
        (units == Units.Metric ? weight : (weight * 0.45359237)) /
        200;
  }

  static DateTime dateTimeToDate(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }
}
