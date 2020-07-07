import 'package:abetterme/common/helpers.dart';
import 'package:abetterme/providers/workout_entries.dart';
import 'package:after_init/after_init.dart';
import 'package:fl_animated_linechart/chart/animated_line_chart.dart';
import 'package:fl_animated_linechart/fl_animated_linechart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../common/classes/daily_workout_entry.dart';
import '../models/workout_entries/workout_entry.dart';
import '../providers/profiles.dart';
import '../widgets/common/custom_icon_button.dart';
import '../widgets/overview/daily_workout_overview.dart';
import '../widgets/drawer/app_drawer.dart';

class OverviewScreen extends StatefulWidget {
  static const routeName = "/dashboard";

  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> with AfterInitMixin {
  DateTime _lastSunday;
  DateTime _nextMonday;
  List<WorkoutEntry> _entries;
  Map<DateTime, List<WorkoutEntry>> _mappedValues;
  bool _isLoading = false;

  @override
  void didInitState() {
    final workoutEntriesProvider =
        Provider.of<WorkoutEntries>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    workoutEntriesProvider.fetchWorkoutEntries().then((entries) {
      Map<DateTime, List<WorkoutEntry>> mappedValues = Map();
      for (int i = 0; i < entries.length; i++) {
        final dt = Helpers.dateTimeToDate(entries[i].timestamp);
        if (!mappedValues.containsKey(dt)) {
          mappedValues[dt] = [entries[i]];
          continue;
        }
        mappedValues[dt].add(entries[i]);
      }

      // date-as-string: [WorkoutEntry]
      final latestDate = DateTime.now();
      final lastMondayDate = DateTime(
          // Not actually monday ... add + 1 to get monday
          latestDate.year,
          latestDate.month,
          latestDate.day - latestDate.weekday);

      setState(() {
        _lastSunday = lastMondayDate;
        _mappedValues = mappedValues;
        _nextMonday = _lastSunday.add(Duration(days: 8));
        _isLoading = false;
        _entries = entries;
      });
    });
  }

  List<DailyWorkoutEntry> _calculateWeeklyEntries() {
    Map<DateTime, DailyWorkoutEntry> weeklyEntries = Map();
    final mappedValues = {..._mappedValues};
    final currentWeek = mappedValues.keys
        .where((dt) => dt.isAfter(_lastSunday) && dt.isBefore(_nextMonday))
        .toList();

    // Pre populate with empty
    for (int i = 1; i <= 7; i++) {
      final dt = _lastSunday.add(Duration(days: i));
      weeklyEntries[dt] = DailyWorkoutEntry(dt, []);
    }

    // Reasign non empty
    for (int i = 0; i < currentWeek.length; i++) {
      final weekDate = currentWeek[i];
      weeklyEntries[weekDate] = DailyWorkoutEntry(
        weekDate,
        mappedValues[weekDate],
      );
    }

    List<DailyWorkoutEntry> dailyEntries = weeklyEntries.values.toList();
    dailyEntries.sort((a, b) => a.date.compareTo(b.date));
    return dailyEntries;
  }

  List<Widget> _buildWeekly() {
    return _calculateWeeklyEntries()
        .map((e) => DailyWorkoutOverview(date: e.date, entries: e.entries))
        .toList();
  }

  AnimatedLineChart _buildLineChart() {
    final entries = Map<DateTime, double>.fromEntries(_calculateWeeklyEntries()
        .map((e) => MapEntry(e.date, e.calculateDailyCalories)));
    LineChart chart = LineChart.fromDateTimeMaps(
      [entries],
      [Colors.orange],
      ["kcal"],
    );
    return AnimatedLineChart(chart, key: UniqueKey());
  }

  Container _buildDateNavigation() {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Row(
        children: <Widget>[
          ABMIconButton(
            backgroundColor: Colors.orange,
            splashColor: Colors.green,
            icon: Icon(
              Icons.arrow_left,
              color: Colors.white,
            ),
            onTap: () => setState(() {
              _lastSunday = _lastSunday.subtract(Duration(days: 7));
              _nextMonday = _nextMonday.subtract(Duration(days: 7));
            }),
          ),
          Text(
            "${DateFormat(DateFormat.ABBR_MONTH_WEEKDAY_DAY).format(_lastSunday.add(Duration(days: 1)))} - ${DateFormat(DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY).format(_nextMonday.subtract(Duration(days: 1)))}",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          ABMIconButton(
            backgroundColor: Colors.orange,
            splashColor: Colors.green,
            icon: Icon(
              Icons.arrow_right,
              color: Colors.white,
            ),
            onTap: () => setState(() {
              _lastSunday = _lastSunday.add(Duration(days: 7));
              _nextMonday = _nextMonday.add(Duration(days: 7));
            }),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Overview"),
      ),
      body: _isLoading
          ? Center(
              child: SpinKitWave(
                color: Colors.grey,
              ),
            )
          : SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(247, 247, 247, 1),
                ),
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: Consumer<Profiles>(
                  builder: (ctx, profilesProvider, _) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        children: <Widget>[
                          Card(
                            elevation: 10,
                            child: Container(
                              child: _buildLineChart(),
                              padding: const EdgeInsets.only(
                                top: 20,
                                left: 8,
                                right: 8,
                              ),
                              height: 320,
                              width: double.infinity,
                            ),
                          ),
                          _buildDateNavigation(),
                          ..._buildWeekly(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
