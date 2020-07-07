import 'package:abetterme/models/workout_entries/workout_entry.dart';
import 'package:abetterme/widgets/workouts/workout_entry_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../common/custom_icon_button.dart';

class DailyWorkoutOverview extends StatefulWidget {
  static const double textSize = 19;
  final DateTime date;
  final List<WorkoutEntry> entries;

  DailyWorkoutOverview({
    @required this.date,
    @required this.entries,
  });

  @override
  _DailyWorkoutOverviewState createState() => _DailyWorkoutOverviewState();
}

class _DailyWorkoutOverviewState extends State<DailyWorkoutOverview> {
  bool _isExpanded = false;

  double calculateDailyCaloriesBurned() {
    if (widget.entries.isEmpty) return 0;
    return widget.entries
        .map((e) => e.caloriesBurned)
        .reduce((value, element) => value + element);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${DateFormat(DateFormat.WEEKDAY).format(widget.date)} (${calculateDailyCaloriesBurned().toStringAsFixed(2)} kcal)",
                      style: TextStyle(
                        fontSize: DailyWorkoutOverview.textSize,
                        color: Colors.orange,
                      ),
                    ),
                    Text(
                      "(${DateFormat(DateFormat.YEAR_NUM_MONTH_DAY).format(widget.date).toString()})",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                if (widget.entries.isNotEmpty)
                  ABMIconButton(
                    icon: Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more),
                    onTap: () => setState(() => _isExpanded = !_isExpanded),
                    iconPadding: const EdgeInsets.all(6),
                  )
              ],
            ),
            if (_isExpanded)
              ...[...widget.entries].map((e) => WorkoutEntryCard(e))
          ],
        ),
      ),
    );
  }
}
