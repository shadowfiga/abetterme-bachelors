import 'package:abetterme/models/exercises/exercise.dart';
import 'package:abetterme/widgets/common/custom_icon_button.dart';
import 'package:abetterme/widgets/exercises/exercise_info_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExerciseInfoList extends StatefulWidget {
  final List<Exercise> exercises;
  final String listTitle;
  final Widget Function(Exercise e) builder;
  final EdgeInsets margin;

  ExerciseInfoList(this.exercises, this.listTitle,
      {this.builder, this.margin = const EdgeInsets.all(0.0)});

  @override
  _ExerciseInfoListState createState() => _ExerciseInfoListState();
}

class _ExerciseInfoListState extends State<ExerciseInfoList> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final calculatedHeight = (widget.exercises.length * 50.0);
    return Container(
      margin: widget.margin,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(widget.listTitle,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.orange,
                  )),
              ABMIconButton(
                icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                iconPadding: const EdgeInsets.all(6),
              ),
            ],
          ),
          if (_isExpanded) ...[
            Divider(
              color: Colors.black,
            ),
            Container(
              height: calculatedHeight > 300 ? 300 : calculatedHeight,
              child: ListView.builder(
                itemBuilder: (ctx, idx) => widget.builder != null
                    ? widget.builder(widget.exercises[idx])
                    : ExerciseInfoItem(
                        widget.exercises[idx].name,
                        widget.exercises[idx].uid,
                      ),
                itemCount: widget.exercises.length,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
