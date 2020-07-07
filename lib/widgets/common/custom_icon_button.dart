import 'package:abetterme/widgets/common/custom_circular_button.dart';
import 'package:flutter/material.dart';

class ABMIconButton extends StatelessWidget {
  final Color backgroundColor;
  final Color splashColor;
  final Icon icon;
  final EdgeInsets iconPadding;
  final EdgeInsets iconMargin;
  final Function onTap;

  ABMIconButton({
    @required this.icon,
    @required this.onTap,
    this.iconPadding = const EdgeInsets.all(10),
    this.iconMargin = const EdgeInsets.only(),
    this.backgroundColor = Colors.white,
    this.splashColor = Colors.orange,
  });

  @override
  Widget build(BuildContext context) {
    return CustomRoundedButton(
      child: Container(
        padding: iconPadding,
        child: icon,
      ),
      onTap: onTap,
      backgroundColor: backgroundColor,
      splashColor: splashColor,
      margin: iconMargin,
    );
  }
}
