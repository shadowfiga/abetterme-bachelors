import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../models/workout_entries/workout_entry.dart';
import '../../screens/workout_entries/quick_workout.dart';
import '../common/custom_icon_button.dart';
import '../../screens/workout_entries/standard_workout.dart';
import '../exercises/exercise_info_item.dart';

class WorkoutEntryCard extends StatefulWidget {
  final WorkoutEntry workoutEntry;
  WorkoutEntryCard(this.workoutEntry);

  @override
  _WorkoutEntryCardState createState() => _WorkoutEntryCardState();
}

class _WorkoutEntryCardState extends State<WorkoutEntryCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(
          color: Colors.orange,
          thickness: 1.3,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              (widget.workoutEntry.isQuickWorkout
                      ? "Quick Workout"
                      : widget.workoutEntry.standardWorkoutEntry.name) +
                  "(${widget.workoutEntry.caloriesBurned.toStringAsFixed(2)} kcal)",
              style: TextStyle(fontSize: 16),
            ),
            Row(
              children: <Widget>[
                ABMIconButton(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  icon: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
                  iconPadding: const EdgeInsets.all(4),
                ),
                ABMIconButton(
                  onTap: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (ctx) => widget.workoutEntry.isQuickWorkout
                          ? QuickWorkoutScreen(
                              workoutEntry: widget.workoutEntry,
                            )
                          : StandardWorkoutScreen(
                              workoutEntry: widget.workoutEntry,
                            ),
                    ),
                  ),
                  icon: const Icon(
                    Icons.arrow_right,
                    color: Colors.green,
                  ),
                  iconPadding: const EdgeInsets.all(6),
                ),
              ],
            )
          ],
        ),
        if (_isExpanded) ...[
          Divider(
            color: Colors.black,
          ),
          ...(widget.workoutEntry.isQuickWorkout
              ? [...widget.workoutEntry.quickWorkoutEntry.exercises]
                  .map((e) => ExerciseInfoItem(e.name, e.uid))
              : [...widget.workoutEntry.standardWorkoutEntry.exercises].map(
                  (e) => ExerciseInfoItem(
                    e.name,
                    e.uid,
                    sets: e.sets,
                  ),
                )),
        ]
      ],
    );
  }
}
