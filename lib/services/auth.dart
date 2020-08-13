import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

// A generic class to decouple all the authentication code provided by
// the dart firebase plugin so that it returns a user of type User
// instead of type FirebaseUser
class User {
  User({@required this.uid});
  final String uid;
}

// create an abstract class/interface to make our Auth class entirely free from
// firebase specific methods
abstract class AuthBase {
  Stream<User> get onAuthStateChange;
  Future<User> currentUser();
  Future<User> signInAnonymously();
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
  Future<User> signInWithEmail(String email, String password);
  Future<User> createAccountWithEmail(String email, String password);
  Future<void> signOut();
}

class Auth implements AuthBase {
  // store firebase instance in a variable
  final _firebaseAuth = FirebaseAuth.instance;

  // function that takes a user of type FirebaseUser and returns a user
  // of type User
  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return User(uid: user.uid);
  }

  // Stream to listen to the change in authentication
  // returns a user of type User
  @override
  Stream<User> get onAuthStateChange {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  // asynchronous function that returns a current user
  @override
  Future<User> currentUser() async {
    final user = await _firebaseAuth.currentUser();
    return _userFromFirebase(user);
  }

  // asynchronous function that returns an anonymous user after signing in
  @override
  Future<User> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> signInWithGoogle() async {
    // creating an object of type google sign in
    final googleSignIn = GoogleSignIn();

    // object for letting the user sign in
    final googleSignInAccount = await googleSignIn.signIn();

    // check to see if we've received the access token or not
    if (googleSignInAccount != null) {
      // authorize the user
      final googleSignInAuthentication =
          await googleSignInAccount.authentication;
      if (googleSignInAuthentication.idToken != null &&
          googleSignInAuthentication.accessToken != null) {
        final authResult = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.getCredential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken,
          ),
        );
        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
            code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
            message: 'Missing Google Auth Token');
      }
    } else {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign In aborted by user');
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['public_profile']);
    if (result.accessToken != null) {
      final authResult = await _firebaseAuth.signInWithCredential(
        FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token,
        ),
      );
      return _userFromFirebase(authResult.user);
    } else {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign In aborted by user');
    }
  }

  @override
  Future<User> signInWithEmail(String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> createAccountWithEmail(String email, String password) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  // asynchronous function that let's user sign out
  @override
  Future<void> signOut() async {
    // signOut with google
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();

    // logOut from facebook
    final facebookLogin = FacebookLogin();
    await facebookLogin.logOut();

    // signOut from firebase
    await _firebaseAuth.signOut();
  }
}
