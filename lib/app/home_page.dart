import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/custom_widget/platform_alert_dialogue.dart';
import 'package:time_tracker/services/auth.dart';

class HomePage extends StatelessWidget {

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialogue(
      title: 'Logout',
      content: 'Are you sure you want to logout',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    ).show(context);

    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Activity Tracker"),
        elevation: 2.0,
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Logout",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
    );
  }
}
