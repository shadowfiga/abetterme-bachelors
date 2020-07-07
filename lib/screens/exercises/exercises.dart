import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../providers/exercises.dart';
import '../../widgets/drawer/app_drawer.dart';
import '../../models/exercises/exercise.dart';
import '../../widgets/exercises/exercise_item.dart';

enum UserExercisesViewMode { View, Edit }

enum AppBarMode { Show, Search }

class ExercisesScreen extends StatefulWidget {
  static const routeName = "/exercises";

  @override
  _ExercisesScreenState createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  var _tabIndex = 0;

  AppBarMode appBarMode = AppBarMode.Show;
  final SearchBarController<Exercise> _searchBarController =
      SearchBarController();

  Future<List<Exercise>> _delayedSearch(String query) async {
    return await Provider.of<Exercises>(context, listen: false)
        .searchByName(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exercises"),
        centerTitle: true,
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Exercises>(context, listen: false).fetchExercises(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SpinKitWave(
              color: Colors.grey,
            );
          } else if (snapshot.hasError) {
            return Center(
              child: const Text("Could not fetch exercises at the moment."),
            );
          } else {
            return Consumer<Exercises>(builder: (ctx, exercisesProvider, _) {
              final favoriteExercises = exercisesProvider.profile.favExercises;
              return SafeArea(
                child: SearchBar<Exercise>(
                  mainAxisSpacing: 20,
                  hintText: "Bear Crawl",
                  searchBarController: _searchBarController,
                  searchBarPadding: const EdgeInsets.symmetric(horizontal: 10),
                  searchBarStyle: SearchBarStyle(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  loader: SpinKitWave(
                    color: Colors.grey,
                  ),
                  onItemFound: (exercise, index) => ExerciseItem(
                    // Force rebuild ...
                    onTap: () => setState(() {}),
                    exercise: exercise,
                    isFavorite: favoriteExercises.contains(exercise.uid),
                  ),
                  onSearch: _delayedSearch,
                  emptyWidget: Center(
                    child: Text(
                      "Could not find any exercises with the given name.",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  suggestions: exercisesProvider.hasExercises
                      ? _tabIndex == 0
                          ? exercisesProvider.exercises
                          : exercisesProvider.favoriteExercises
                      : [],
                  buildSuggestion: (exercise, index) => ExerciseItem(
                    exercise: exercise,
                    isFavorite: favoriteExercises.contains(exercise.uid),
                    // Force rebuild ...
                    onTap: () => setState(() {}),
                  ),
                ),
              );
            });
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        onTap: (index) {
          setState(() {
            _tabIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Exercises"),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            title: const Text("Favorites"),
          )
        ],
      ),
    );
  }
}
