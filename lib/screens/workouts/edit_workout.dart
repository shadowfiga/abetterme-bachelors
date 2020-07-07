import 'package:abetterme/widgets/common/form_container.dart';
import 'package:after_init/after_init.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../models/workouts/workout.dart';
import '../../providers/workouts.dart';
import '../../models/exercises/exercise.dart';
import '../../models/common/exercise_description.dart';
import '../../providers/exercises.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/exercises/exercise_info_list.dart';

class EditWorkoutScreen extends StatefulWidget {
  static const routeName = '/workouts-edit';

  @override
  _EditWorkoutScreenState createState() => _EditWorkoutScreenState();
}

class _EditWorkoutScreenState extends State<EditWorkoutScreen>
    with AfterInitMixin {
  final _workoutFormKey = GlobalKey<FormState>();
  Workout _workout;
  List<Exercise> _exercises = [];
  List<Exercise> _favoriteExercises = [];
  List<String> _favoriteExerciseIds = [];
  List<String> _exerciseIds = [];
  int numberOfSearchResults = 0;
  bool _isNew = true;
  bool _isLoading = false;

  final SearchBarController<Exercise> _searchBarController =
      SearchBarController();

  @override
  Future<void> didInitState() async {
    final exercisesProvider = Provider.of<Exercises>(context, listen: false);
    final args = ModalRoute.of(context).settings.arguments;
    Workout workout;
    List<Exercise> exercises = [];
    List<String> exerciseIds = [];
    bool isNew = true;
    setState(() => _isLoading = true);
    if (args == null) {
      workout = Workout.empty();
    } else {
      workout = await Provider.of<Workouts>(context, listen: false)
          .getById(args as String);
      exerciseIds = workout.exercises.map((e) => e.exerciseId).toList();
      exercises = await exercisesProvider.getMultyByIds(exerciseIds);
      if (workout == null) {
        Navigator.of(context).pop();
        return;
      }
      isNew = false;
    }
    final favoriteExercises = await exercisesProvider.getFavoriteExercises();
    setState(() {
      _exercises = exercises;
      _exerciseIds = exerciseIds;
      _workout = workout;
      _isNew = isNew;
      _isLoading = false;
      _favoriteExerciseIds = [...favoriteExercises].map((e) => e.uid).toList();
      _favoriteExercises = favoriteExercises
          .where((e) => !_exerciseIds.contains(e.uid))
          .toList();
    });
  }

  InputDecoration _buildDecoration(String label) {
    return InputDecoration(
      labelText: label,
      isDense: true,
    );
  }

  Future<void> _submit(BuildContext ctx) async {
    if (!_workoutFormKey.currentState.validate() || _exercises.isEmpty) return;
    _workout.exercises = _exercises
        .map<ExerciseDescription>((e) => ExerciseDescription(
              exerciseId: e.uid,
              exerciseName: e.name,
              mets: e.mets,
            ))
        .toList();

    final workoutsProvider = Provider.of<Workouts>(context, listen: false);
    if (_isNew) {
      await workoutsProvider.createWorkout(_workout);
      Navigator.pop(ctx, "Workout created.");
    } else {
      await workoutsProvider.updateWorkout(_workout);
      Navigator.pop(ctx, "Workout updated.");
    }
  }

  Future<List<Exercise>> _search(String query) async {
    final result = await Provider.of<Exercises>(context, listen: false)
        .searchByName(query);
    result.removeWhere((e) => _exerciseIds.contains(e.uid));
    setState(() => numberOfSearchResults = result.length);
    return result;
  }

  void _addExerciseToWorkout(Exercise e) {
    if (!_exerciseIds.contains(e.uid) && !_exercises.contains(e)) {
      setState(() {
        _exercises.add(e);
        _exerciseIds.add(e.uid);
        _favoriteExercises.remove(e);
      });
      _searchBarController.replayLastSearch();
    }
  }

  void _removeExerciseFromWorkout(Exercise e) {
    setState(() {
      _exercises.remove(e);
      _exerciseIds.remove(e.uid);
      if (_favoriteExerciseIds.contains(e.uid)) {
        _favoriteExercises.add(e);
      }
    });
    _searchBarController.replayLastSearch();
  }

  Widget _buildExerciseTile(Exercise e, {bool canDelete = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        ConstrainedBox(
          child: Text(e.name),
          constraints: BoxConstraints(maxWidth: 300),
        ),
        IconButton(
          onPressed: () => canDelete
              ? _removeExerciseFromWorkout(e)
              : _addExerciseToWorkout(e),
          icon: Icon(canDelete ? Icons.remove : Icons.add),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew ? "Create Workout" : _workout.name),
        centerTitle: true,
      ),
      body: _isLoading
          ? SpinKitWave(
              color: Colors.grey,
            )
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    FormChildContainer(
                      margin: const EdgeInsets.only(
                        top: 8,
                        left: 8,
                        right: 8,
                      ),
                      child: Form(
                        key: _workoutFormKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              decoration: _buildDecoration("Workout Name"),
                              initialValue: _workout.name,
                              onChanged: (val) =>
                                  setState(() => _workout.name = val),
                              validator: (String val) => val.isEmpty
                                  ? "You must specify a name for the workout"
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 300,
                      child: SearchBar<Exercise>(
                        searchBarController: _searchBarController,
                        shrinkWrap: true,
                        listPadding: const EdgeInsets.symmetric(horizontal: 10),
                        loader: SpinKitWave(
                          color: Colors.grey,
                        ),
                        minimumChars: 2,
                        hintText: "Bear Crawl",
                        searchBarPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        searchBarStyle: SearchBarStyle(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        onItemFound: (exercise, _) =>
                            _buildExerciseTile(exercise),
                        onCancelled: () => setState(() {
                          numberOfSearchResults = 0;
                          _searchBarController.replayLastSearch();
                        }),
                        onSearch: _search,
                        emptyWidget: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: const Text(
                              "No results have been found matching the query or you have added all the possibilities to a workout."),
                        ),
                        placeHolder: _favoriteExercises.isEmpty
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: const Text(
                                    "Please search for the exercises you would like to add to the workout."))
                            : null,
                        buildSuggestion: (exercise, _) =>
                            _buildExerciseTile(exercise),
                        suggestions: _favoriteExercises,
                      ),
                    ),
                    if (_exercises.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(color: Colors.white),
                        width: double.infinity,
                        child: Column(
                          children: [
                            FormChildContainer(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              child: ExerciseInfoList(
                                _exercises,
                                "Selected exercises",
                                builder: (e) =>
                                    _buildExerciseTile(e, canDelete: true),
                              ),
                            ),
                            Builder(
                              builder: (ctx) => CustomButton(
                                child: Text(_isNew
                                    ? "Create Workout"
                                    : "Update Workout"),
                                onTap: () => _submit(ctx),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
