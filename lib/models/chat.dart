import 'package:cloud_firestore/cloud_firestore.dart';
import 'message.dart';

class Chat {
  DocumentSnapshot ds;
  String chatID;
  List<String> users;
  Message recentMessage;
  dynamic createdAt, updatedAt;

  Chat({
    this.ds,
    this.chatID,
    this.users,
    this.recentMessage,
    this.createdAt,
    this.updatedAt,
  });

  List<Message> messages = [];

  static Chat model({DocumentSnapshot ds, String id, Map map}) => Chat(
        ds: ds,
        chatID: id,
        users: map['users'] == null
            ? []
            : (map['users'] as List<dynamic>).map((e) => e.toString()).toList(),
        recentMessage: map['recentMessage'] == null
            ? null
            : Message.model(map: map['recentMessage']),
        createdAt: map['createdAt'] == null
            ? DateTime.now()
            : (map['createdAt'] as Timestamp).toDate(),
        updatedAt: map['updatedAt'] == null
            ? DateTime.now()
            : (map['updatedAt'] as Timestamp).toDate(),
      );

  Map<String, dynamic> map() => <String, dynamic>{
        'users': this.users,
        'recentMessage':
            this.recentMessage == null ? null : this.recentMessage.map(),
        'createdAt': this.createdAt,
        'updatedAt': this.updatedAt,
      };
}
