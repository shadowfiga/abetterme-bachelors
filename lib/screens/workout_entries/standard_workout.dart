import 'package:abetterme/common/helpers.dart';
import 'package:abetterme/models/workout_entries/standard_workout_entry.dart';
import 'package:abetterme/models/workout_entries/standard_workout_entry_exercise.dart';
import 'package:abetterme/models/workout_entries/workout_entry.dart';
import 'package:abetterme/providers/workout_entries.dart';
import 'package:abetterme/providers/workouts.dart';
import 'package:abetterme/screens/exercises/exercise_detail.dart';
import 'package:abetterme/widgets/common/custom_circular_button.dart';
import 'package:abetterme/widgets/common/custom_icon_button.dart';
import 'package:abetterme/widgets/drawer/app_drawer.dart';
import 'package:after_init/after_init.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../overview.dart';

class StandardWorkoutScreen extends StatefulWidget {
  static const routeName = '/standard-workout';
  final WorkoutEntry workoutEntry;
  StandardWorkoutScreen({this.workoutEntry});

  @override
  _StandardWorkoutScreenState createState() => _StandardWorkoutScreenState();
}

class _StandardWorkoutScreenState extends State<StandardWorkoutScreen>
    with AfterInitMixin {
  List<StandardWorkoutEntryExercise> _exercises = [];
  int _currentIndex = 0;
  bool _isLoading = false;
  String _name;

  @override
  void didInitState() {
    if (widget.workoutEntry != null) {
      setState(() {
        _name = widget.workoutEntry.standardWorkoutEntry.name;
        _exercises = [...widget.workoutEntry.standardWorkoutEntry.exercises]
            .map((e) => StandardWorkoutEntryExercise(0, e.uid, e.name, e.mets))
            .toList();
        _isLoading = false;
      });
    } else {
      final workoutId = ModalRoute.of(context).settings.arguments as String;
      setState(() => _isLoading = true);
      Provider.of<Workouts>(context)
          .getById(workoutId)
          .then((w) => setState(() {
                _name = w.name;
                _exercises = [...w.exercises]
                    .map((e) => StandardWorkoutEntryExercise(
                          0,
                          e.exerciseId,
                          e.exerciseName,
                          e.mets,
                        ))
                    .toList();
                _isLoading = false;
              }));
    }
  }

  Future<void> _submit() async {
    final provider = Provider.of<WorkoutEntries>(context, listen: false);
    await provider.addWorkoutEntry(WorkoutEntry(
        standardWorkoutEntry: StandardWorkoutEntry(
      _name,
      _exercises,
      _exercises
          .map((e) =>
              Helpers.calculateCaloriesPerMinute(
                mets: e.mets,
                weight: provider.profile.weight,
                units: provider.profile.units,
              ) *
              e.sets)
          .reduce((value, element) => value + element),
    )));
    Navigator.of(context).pushReplacementNamed(OverviewScreen.routeName);
  }

  Widget _buildSetCounter() {
    final currentExercise = _exercises[_currentIndex];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ABMIconButton(
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.green,
          onTap: () => setState(() => currentExercise.sets++),
        ),
        SizedBox(
          width: 10,
        ),
        ABMIconButton(
          icon: Icon(
            Icons.remove,
            color: Colors.white,
          ),
          backgroundColor: currentExercise.sets == 0 ? Colors.grey : Colors.red,
          splashColor: Colors.yellow,
          onTap: () => currentExercise.sets == 0
              ? {}
              : setState(() => currentExercise.sets--),
        ),
      ],
    );
  }

  Widget _buildNextPrevExercise() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ABMIconButton(
          icon: Icon(
            Icons.navigate_before,
            color: Colors.white,
          ),
          onTap: () =>
              _currentIndex - 1 < 0 ? {} : setState(() => _currentIndex--),
          backgroundColor: _currentIndex - 1 < 0 ? Colors.grey : Colors.orange,
          splashColor: Colors.yellow,
        ),
        SizedBox(
          width: 10,
        ),
        ABMIconButton(
          icon: Icon(
            Icons.navigate_next,
            color: Colors.white,
          ),
          onTap: () => _currentIndex == _exercises.length - 1
              ? {}
              : setState(() => _currentIndex++),
          backgroundColor: _currentIndex == _exercises.length - 1
              ? Colors.grey
              : Colors.orange,
          splashColor: Colors.yellow,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Workout"),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: SpinKitWave(
                color: Colors.grey,
              ),
            )
          : Container(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        _exercises[_currentIndex].name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.orange,
                        ),
                      ),
                      ABMIconButton(
                        icon: const Icon(Icons.info),
                        onTap: () => Navigator.of(context).pushNamed(
                            ExerciseDetailScreen.routeName,
                            arguments: _exercises[_currentIndex].uid),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Sets: ${_exercises[_currentIndex].sets}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _buildSetCounter(),
                  SizedBox(
                    height: 10,
                  ),
                  _buildNextPrevExercise(),
                  SizedBox(
                    height: 10,
                  ),
                  if (_exercises.any((e) => e.sets > 0))
                    CustomRoundedButton(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          "DONE",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      backgroundColor: Colors.redAccent,
                      splashColor: Colors.green,
                      onTap: _submit,
                      borderRadius: 60,
                    ),
                ],
              ),
            ),
      drawer: AppDrawer(),
    );
  }
}
