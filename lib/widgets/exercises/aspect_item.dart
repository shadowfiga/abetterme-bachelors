import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../models/exercises/aspect.dart';

class AspectItem extends StatefulWidget {
  final Aspect aspect;

  AspectItem(this.aspect);

  @override
  _AspectItemState createState() => _AspectItemState();
}

class _AspectItemState extends State<AspectItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              widget.aspect.name,
              style: TextStyle(
                color: Colors.orange,
                fontSize: 16,
              ),
            ),
            IconButton(
              icon: Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
              ),
              onPressed: () => setState(() => isExpanded = !isExpanded),
            )
          ],
        ),
        if (isExpanded) ...[
          Text(
            widget.aspect.description,
            textAlign: TextAlign.justify,
          ),
        ]
      ],
    );
  }
}
