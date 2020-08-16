import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  CustomRaisedButton({
    this.child,
    this.color,
    this.borderRadius : 4.0,
    this.height : 50.0,
    this.onPressed
  }) : assert(borderRadius != null && height != null);

  final Widget child;
  final Color color;
  final double borderRadius;
  final double height;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: RaisedButton(
        color: color,
        disabledColor: color,
        child: child,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(borderRadius)
            )
        ),
        onPressed: onPressed,
      ),
    );
  }
}
