import 'package:abetterme/providers/exercises.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../models/workouts/workout.dart';
import '../../providers/workouts.dart';
import '../../widgets/drawer/app_drawer.dart';
import '../../widgets/workouts/edit_entity_list_tile.dart';
import '../../widgets/workouts/workout_card.dart';
import 'edit_workout.dart';

class WorkoutsScreen extends StatefulWidget {
  static const routeName = "/workouts";

  @override
  _WorkoutsScreenState createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  int _tabIndex = 0;

  final SearchBarController<Workout> _searchBarController =
      SearchBarController();

  Widget buildWorkoutCard(Workout workout) {
    return WorkoutCard(workout);
  }

  Future<List<Workout>> _search(String query) async {
    return await Provider.of<Workouts>(context, listen: false)
        .searchByName(query);
  }

  List<Workout> _createSuggestions(Workouts provider) {
    List<Workout> selected = [];
    switch (_tabIndex) {
      case 0:
        selected = provider.workouts;
        break;
      case 1:
        selected = provider.userWorkouts;
        break;
      default:
    }
    return selected;
  }

  Widget _buildSuggestion(Workout workout) {
    Widget suggestion;
    switch (_tabIndex) {
      case 0:
        suggestion = buildWorkoutCard(workout);
        break;
      case 1:
        suggestion = EditEntityListTile(workout, EditWorkoutScreen.routeName);
        break;
      default:
    }
    return suggestion;
  }

  Widget _buildNavigation() => BottomNavigationBar(
        currentIndex: _tabIndex,
        onTap: (index) => setState(() {
          _tabIndex = index;
        }),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Workouts"),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            title: const Text("My Workouts"),
          ),
        ],
      );

  _pushEditWorkoutsNavigation(BuildContext ctx) async {
    final exercisesProvider = Provider.of<Exercises>(context, listen: false);
    await exercisesProvider.fetchExercises();
    final result = await Navigator.push(
      ctx,
      MaterialPageRoute(builder: (ctx) => EditWorkoutScreen()),
    );
    if (result != null)
      Scaffold.of(ctx)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text("$result"),
          duration: Duration(seconds: 2),
        ));
    // Hacky but it works ... forcefully rebuild and keep context
    setState(() => _tabIndex = 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Workouts"),
        centerTitle: true,
        actions: <Widget>[
          if (_tabIndex == 1)
            Builder(
              builder: (ctx) => IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _pushEditWorkoutsNavigation(ctx),
              ),
            )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future: Provider.of<Workouts>(context, listen: false).fetchWorkouts(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SpinKitWave(
                color: Colors.grey,
              );
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return Consumer<Workouts>(
                  builder: (ctx, workoutsProvider, child) {
                return SafeArea(
                  child: SearchBar<Workout>(
                    hintText: "Pure Strength Workout",
                    searchBarController: _searchBarController,
                    searchBarPadding:
                        const EdgeInsets.symmetric(horizontal: 10),
                    searchBarStyle: SearchBarStyle(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    listPadding: const EdgeInsets.symmetric(horizontal: 10),
                    loader: SpinKitWave(
                      color: Colors.grey,
                    ),
                    onItemFound: (workout, index) => buildWorkoutCard(workout),
                    onSearch: _search,
                    emptyWidget: Center(
                      child: Text(
                        "Could not find any exercises with the given name.",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    suggestions: _createSuggestions(workoutsProvider),
                    buildSuggestion: (workout, index) =>
                        _buildSuggestion(workout),
                  ),
                );
              });
            }
          }),
      bottomNavigationBar: _buildNavigation(),
    );
  }
}
