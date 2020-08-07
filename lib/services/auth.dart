import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

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

  // asynchronous function that returns a user after signing in
  @override
  Future<User> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  // asynchronous function that let's user sign out
  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

}