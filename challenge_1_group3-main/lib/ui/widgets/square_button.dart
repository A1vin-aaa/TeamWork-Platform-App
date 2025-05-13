import 'package:flutter/cupertino.dart';

class SquareButton extends StatelessWidget {
  final dynamic icon;
  final Color bgColor;
  final Color contentColor;
  final VoidCallback onPressed;
  const SquareButton(
      {super.key,
      required this.icon,
      required this.bgColor,
      required this.contentColor,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        height: 42,
        width: 42,
        decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: contentColor),
            borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: SizedBox(
              height: 24,
              width: 24,
              child: Icon(
                icon,
                color: contentColor,
              )),
        ),
      ),
    );
  }
}
