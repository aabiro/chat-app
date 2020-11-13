import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/models/user.dart';

class UserProvider extends ChangeNotifier {
  CollectionReference _collection =
      FirebaseFirestore.instance.collection('users');

  Future createUser({String uid, String email}) async {
    return await this._collection.doc(uid).set(<String, dynamic>{
      'email': email,
    });
  }

  Future<User> readUser({String uid}) async {
    DocumentSnapshot ds = await this._collection.doc(uid).get();
    return User.model(ds: ds, id: ds.id, map: ds.data());
  }

  Stream<List<User>> readUsers() {
    return this._collection.snapshots().map((event) => event.docs
        .map((documentSnapshot) => User.model(
              ds: documentSnapshot,
              id: documentSnapshot.id,
              map: documentSnapshot.data(),
            ))
        .toList()
        .reversed
        .toList());
  }
}
