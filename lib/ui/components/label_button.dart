import 'package:flutter/material.dart';

class LabelButton extends StatelessWidget {
  LabelButton({this.labelText, this.onPressed, this.style});
  final String labelText;
  final ButtonStyle style;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: style,
      child: Text(
        labelText,
      ),
      onPressed: onPressed,
    );
  }
}
