import 'package:flutter/material.dart';
/*
LabelButton(
                labelText: 'Some Text',
                onPressed: () => print('implement me'),
              ),
*/

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
