import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  DocumentSnapshot ds;
  String messageID;
  String owner;
  String msg;
  dynamic createdAt;

  Message({
    this.ds,
    this.messageID,
    this.owner,
    this.msg,
    this.createdAt,
  });

  static Message model({DocumentSnapshot ds, String id, Map map}) => Message(
        ds: ds,
        messageID: id,
        owner: map['owner'],
        msg: map['msg'],
        createdAt: map['createdAt'] == null
            ? DateTime.now()
            : (map['createdAt'] as Timestamp).toDate(),
      );

  Map<String, dynamic> map() => <String, dynamic>{
        'owner': this.owner,
        'msg': this.msg,
        'createdAt': this.createdAt,
      };
}
