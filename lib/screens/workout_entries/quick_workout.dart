import 'dart:math';

import 'package:abetterme/common/enums/units.dart';
import 'package:abetterme/common/helpers.dart';
import 'package:abetterme/models/workout_entries/quick_workout_entry.dart';
import 'package:abetterme/models/workout_entries/quick_workout_entry_exercise.dart';
import 'package:abetterme/models/workout_entries/workout_entry.dart';
import 'package:abetterme/providers/profiles.dart';
import 'package:abetterme/providers/workout_entries.dart';
import 'package:after_init/after_init.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

import '../../providers/exercises.dart';
import '../overview.dart';
import '../exercises/exercise_detail.dart';
import '../../widgets/drawer/app_drawer.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_icon_button.dart';
import '../../widgets/common/form_container.dart';

enum QuickWorkoutState {
  Setup,
  InProgress,
  Done,
}

enum CountdownState {
  Start,
  Workout,
  Rest,
}

class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);
  final Animation<int> animation;

  @override
  build(BuildContext context) {
    return new Text(
      animation.value.toString(),
      style: new TextStyle(fontSize: 120.0),
    );
  }
}

class QuickWorkoutScreen extends StatefulWidget {
  static const routeName = "/quick-workout";

  final WorkoutEntry workoutEntry;
  QuickWorkoutScreen({this.workoutEntry});

  @override
  _QuickWorkoutScreenState createState() => _QuickWorkoutScreenState();
}

class _QuickWorkoutScreenState extends State<QuickWorkoutScreen>
    with AfterInitMixin, TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _caloriesController = TextEditingController();
  double caloriesToBurn = 0;
  int numberOfExercises = 0;
  int roundCounter = 0;
  CountdownState countdownState = CountdownState.Start;

  AnimationController _animationController;

  double caloriesBurned = 0;
  double _approxCaloriesBurned = 0;
  int _exerciseIndex = 0;
  QuickWorkoutState state = QuickWorkoutState.Setup;
  bool _isPlaying = false;
  bool _isLoading = false;

  List<QuickWorkoutEntryExercise> _exercises;
  int _rounds = 0;

  double _weight = 0;
  Units _units = Units.Metric;

  @override
  void dispose() {
    _caloriesController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didInitState() {
    _animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 10),
    );
    _animationController.addStatusListener(_finishedCountdown);

    final profileProvider = Provider.of<Profiles>(context, listen: false);
    setState(() {
      _weight = profileProvider.profile.weight;
      _units = profileProvider.profile.units;
      if (widget.workoutEntry != null) {
        final quickWorkoutEntry = widget.workoutEntry.quickWorkoutEntry;
        _rounds = quickWorkoutEntry.rounds;
        _exercises = quickWorkoutEntry.exercises;
        state = QuickWorkoutState.InProgress;
      }
    });
  }

  String _validateInputs(String input, {bool checkInt = false}) {
    if (!isNumeric(input)) {
      return 'Please enter a valid number';
    }

    if (checkInt && !isInt(input)) {
      return 'Please enter a non decimal number';
    }

    if (double.parse(input) <= 0) {
      return 'Please enter a number greater than 0';
    }

    return null;
  }

  Future<void> _saveData() async {
    if (caloriesBurned <= 0) return;
    setState(() => _isLoading = true);
    final provider = Provider.of<WorkoutEntries>(context, listen: false);
    WorkoutEntry entry = WorkoutEntry(
        quickWorkoutEntry:
            QuickWorkoutEntry(_rounds, _exercises, caloriesBurned));
    await provider.addWorkoutEntry(entry);
    setState(() => _isLoading = false);
  }

  Future<void> _finishedCountdown(AnimationStatus status) async {
    if (status == AnimationStatus.completed &&
        state != QuickWorkoutState.Done) {
      if (countdownState != CountdownState.Workout) {
        _animationController.duration = Duration(seconds: 60);
        setState(() {
          countdownState = CountdownState.Workout;
        });
      } else {
        _animationController.duration = Duration(seconds: 15);
        setState(() {
          caloriesBurned += Helpers.calculateCaloriesPerMinute(
              mets: _exercises[_exerciseIndex].mets,
              weight: _weight,
              units: _units);
          if (_exerciseIndex + 1 >= _exercises.length) {
            _exerciseIndex = 0;
            roundCounter++;
          } else {
            _exerciseIndex++;
          }
          countdownState = CountdownState.Rest;
        });
      }
      if (roundCounter == _rounds) {
        setState(() => state = QuickWorkoutState.Done);
        await _saveData();
      }
      _animationController.forward(from: 0);
    }
  }

  void _generateQuickWorkout() async {
    if (!_formKey.currentState.validate()) return;
    final exercisesProvider = Provider.of<Exercises>(context, listen: false);
    final exercises = await exercisesProvider.fetchQuickWorkoutExercises();
    int len = (numberOfExercises > exercises.length
        ? exercises.length
        : numberOfExercises);
    List<QuickWorkoutEntryExercise> selectedExercises = [];
    double cals = 0;
    for (int i = len; i > 0; i--) {
      int randomInt = Random().nextInt(i);
      final selectedExercise = exercises[randomInt];
      selectedExercises
          .add(QuickWorkoutEntryExercise.fromExercise(selectedExercise));
      exercises.removeAt(randomInt);
      cals += Helpers.calculateCaloriesPerMinute(
          mets: selectedExercise.mets, weight: _weight, units: _units);
    }
    setState(() {
      _rounds = (caloriesToBurn / cals).ceil();
      _approxCaloriesBurned = _rounds * cals;
      _exercises = selectedExercises;
    });
  }

  Widget _build(QuickWorkoutState currentState) {
    Widget widget;
    switch (currentState) {
      case QuickWorkoutState.Setup:
        widget = SingleChildScrollView(
          child: Column(children: <Widget>[
            Form(
              key: _formKey,
              child: FormChildContainer(
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Calories to burn",
                        isDense: true,
                      ),
                      keyboardType: TextInputType.number,
                      validator: _validateInputs,
                      onChanged: (value) => setState(
                          () => caloriesToBurn = double.tryParse(value)),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Number of exercises",
                        isDense: true,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      validator: (value) =>
                          _validateInputs(value, checkInt: true),
                      onChanged: (value) => setState(
                          () => numberOfExercises = int.tryParse(value)),
                    ),
                  ],
                ),
              ),
            ),
            CustomButton(
              child: const Text("Generate Workout"),
              onTap: _generateQuickWorkout,
            ),
            if (_exercises != null && _exercises.isNotEmpty) ...[
              const Text("Workout:"),
              Text(_approxCaloriesBurned.toStringAsFixed(2)),
              Text(_rounds.toString()),
              FormChildContainer(
                margin: const EdgeInsets.all(10),
                child: Container(
                  height: 200,
                  child: ListView.builder(
                    itemBuilder: (ctx, index) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          _exercises[index].name.length > 40
                              ? _exercises[index].name.substring(0, 40) + "..."
                              : _exercises[index].name,
                        ),
                        IconButton(
                          iconSize: 20,
                          icon: const Icon(Icons.info_outline),
                          onPressed: () => Navigator.of(context).pushNamed(
                            ExerciseDetailScreen.routeName,
                            arguments: _exercises[index].uid,
                          ),
                        )
                      ],
                    ),
                    itemCount: _exercises.length,
                  ),
                ),
              ),
              CustomButton(
                child: const Text("Start Workout"),
                onTap: () =>
                    setState(() => state = QuickWorkoutState.InProgress),
              ),
            ],
          ]),
        );
        break;
      case QuickWorkoutState.InProgress:
        widget = Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Calories burned: ${caloriesBurned.toStringAsFixed(2)}"),
              Text(
                "Round: ${roundCounter + 1}/$_rounds",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
              Text(
                "Exercise: ${_exerciseIndex + 1}/${_exercises.length}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              countdownState != CountdownState.Start
                  ? Text(
                      countdownState == CountdownState.Workout
                          ? "Current exercise: ${_exercises[_exerciseIndex].name}"
                          : "Next up: ${_exercises[_exerciseIndex].name}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.orange,
                      ))
                  : Column(
                      children: <Widget>[
                        Text(
                          "First exercise: ${_exercises[_exerciseIndex].name}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.orange,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Starting in: ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
              SizedBox(
                height: 10,
              ),
              Countdown(
                animation: new StepTween(
                  begin: _animationController.duration.inSeconds,
                  end: 0,
                ).animate(_animationController),
              ),
              SizedBox(
                height: 10,
              ),
              ABMIconButton(
                backgroundColor: Colors.orange,
                icon: _isPlaying
                    ? const Icon(Icons.pause)
                    : const Icon(Icons.play_arrow),
                onTap: () {
                  bool playing = _animationController.isAnimating;
                  if (playing) {
                    _animationController.stop();
                  } else {
                    _animationController.forward();
                  }
                  setState(() => _isPlaying = !playing);
                },
              ),
              SizedBox(
                height: 10,
              ),
              CustomButton(
                child: const Text("Finish"),
                onTap: () async {
                  _animationController.stop();
                  _animationController.reset();
                  setState(() {
                    state = QuickWorkoutState.Done;
                    if (countdownState == CountdownState.Workout) {
                      caloriesBurned += Helpers.calculateCaloriesPerMinute(
                              mets: _exercises[_exerciseIndex].mets,
                              units: _units,
                              weight: _weight) *
                          (_animationController.value / 60);
                    }
                  });
                  await _saveData();
                },
              )
            ],
          ),
        );
        break;
      case QuickWorkoutState.Done:
        widget = Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text("Congrats you have done it."),
              Text(
                  "You have burned ${caloriesBurned.toStringAsFixed(2)} calories in total."),
              SizedBox(
                height: 10,
              ),
              CustomButton(
                child: const Text("To Overview"),
                onTap: () => Navigator.of(context)
                    .pushReplacementNamed(OverviewScreen.routeName),
              ),
            ],
          ),
        );
        break;
      default:
        widget = const Text("Woops! Something went terribly wrong.");
        break;
    }
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quick Workout"),
        centerTitle: true,
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? SpinKitWave(
              color: Colors.grey,
            )
          : _build(state),
    );
  }
}
