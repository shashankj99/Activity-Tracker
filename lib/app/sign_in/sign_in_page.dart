import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_page.dart';
import 'package:time_tracker/app/sign_in/sign_in_button.dart';
import 'package:time_tracker/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker/services/auth.dart';

class SignInPage extends StatelessWidget {

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInAnonymously();
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInWithGoogle();
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInWithFacebook();
    } catch (error) {
      print(error.toString());
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Activity",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w500
                ),
              ),
              Text(
                "Tracker",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w300
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0,),
          Text(
            "Assign your activities with time...",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w200
            ),
          ),
          SizedBox(height: 40.0,),
          SocialSignInButton(
            assetName: 'images/google-logo.png',
            text: 'Sign in with Google',
            textColor: Colors.black87,
            color: Colors.white,
            onPressed: () => _signInWithGoogle(context),
          ),
          SizedBox(height: 8.0,),
          SocialSignInButton(
            assetName: 'images/facebook-logo.png',
            text: 'Sign in with Facebook',
            textColor: Colors.white,
            color: Color(0xFF334D92),
            onPressed: () => _signInWithFacebook(context),
          ),
          SizedBox(height: 8.0,),
          SignInButton(
            text: 'Sign in with Email',
            textColor: Colors.white,
            color: Colors.teal[700],
            onPressed: () => _signInWithEmail(context),
            icon: Icons.email,
          ),
          SizedBox(height: 8.0,),
          Text(
            "Or",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500
            ),
          ),
          SizedBox(height: 8.0,),
          SignInButton(
            text: 'Go Anonymous',
            textColor: Colors.black87,
            color: Colors.lime[300],
            onPressed: () => _signInAnonymously(context),
            icon: Icons.person,
          ),
        ],
      ),
    );
  }
}
