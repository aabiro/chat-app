import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

enum AuthStatus { Null, Authenticated, Unauthenticated }

class AuthProvider with ChangeNotifier {
  FirebaseAuth _firebaseAuth;
  User _user;
  AuthStatus _status = AuthStatus.Null;

  AuthProvider.instance() : _firebaseAuth = _auth {
    _auth.authStateChanges().listen(
      (user) {
        if (user != null) {
          this.user = user;
          this.status = AuthStatus.Authenticated;
        } else {
          this.user = null;
          this.status = AuthStatus.Unauthenticated;
        }

        notifyListeners();
      },
    );
  }

  FirebaseAuth get fireabseAuth => this._firebaseAuth;
  User get user => this._user;
  AuthStatus get status => this._status;

  set user(User value) {
    this._user = value;
    notifyListeners();
  }

  set status(AuthStatus value) {
    this._status = value;
    notifyListeners();
  }

  Future<User> register({String email, String password}) async {
    return (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password))
        .user;
  }

  Future<User> login({String email, String password}) async {
    return (await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password))
        .user;
  }

  Future logout() async {
    await _auth.signOut();

    this.user = null;
    this.status = AuthStatus.Unauthenticated;

    notifyListeners();
  }
}
