import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  DocumentSnapshot ds;
  String userID;
  String email;

  User({
    this.ds,
    this.userID,
    this.email,
  });

  static User model({DocumentSnapshot ds, String id, Map map}) => User(
        ds: ds,
        userID: id,
        email: map['email'] == null ? null : map['email'],
      );

  Map<String, dynamic> map() => <String, dynamic>{
        'email': this.email == null ? null : this.email,
      };
}
