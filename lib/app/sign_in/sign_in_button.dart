import 'package:flutter/material.dart';
import 'package:time_tracker/custom_widget/custom_raised_button.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton({
    @required String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
    IconData icon
  })  : assert(text != null),
        super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(
                icon,
                color: textColor,
              ),
              Text(
                text,
                style: TextStyle(color: textColor, fontSize: 15.0),
              ),
              Opacity(
                opacity: 0.0,
                child: Icon(
                  icon,
                  color: textColor,
                ),
              )
            ],
          ),
          color: color,
          onPressed: onPressed,
        );
}
