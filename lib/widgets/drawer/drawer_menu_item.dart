import 'package:flutter/material.dart';

class DrawerMenuItem extends StatelessWidget {
  final Widget title;
  final Widget icon;
  final Function onTap;
  final MainAxisAlignment alignment;
  final double iconTitleSpacing;

  DrawerMenuItem({
    @required this.title,
    this.icon,
    @required this.onTap,
    this.alignment = MainAxisAlignment.start,
    this.iconTitleSpacing = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          mainAxisAlignment: alignment,
          children: <Widget>[
            if (icon != null) icon,
            SizedBox(
              width: iconTitleSpacing,
            ),
            title,
          ],
        ),
      ),
    );
  }
}
