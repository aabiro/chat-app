import 'dart:async';
import 'package:chat_app/models/chat.dart';
import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  CollectionReference _collection =
      FirebaseFirestore.instance.collection('chats');
  // ignore: cancel_subscriptions
  StreamSubscription _chatsStream;
  List<Chat> _chats = [];

  CollectionReference get collection => this._collection;
  List<Chat> get chats => this._chats;

  set chats(List<Chat> value) {
    this._chats = value;
    notifyListeners();
  }

  readChats() {
    var query = this
        .collection
        .where('users', arrayContainsAny: [
          FirebaseAuth.instance.currentUser.uid,
        ])
        .orderBy('updatedAt', descending: true)
        .limit(10);

    if (this.chats.isNotEmpty)
      query = query.startAfterDocument(this.chats.last.ds);

    this._chatsStream = query.snapshots().listen(
          (data) => data.docs.isEmpty
              ? () {}
              : data.docChanges.forEach((change) {
                  if (change.type == DocumentChangeType.added) {
                    print('CHAT ADDED');
                    this.chats.add(
                          Chat.model(
                            ds: change.doc,
                            id: change.doc.id,
                            map: change.doc.data(),
                          ),
                        );

                    notifyListeners();
                  }
                  if (change.type == DocumentChangeType.modified) {
                    print('CHAT MODIFED');
                    Chat chat = Chat.model(
                      ds: change.doc,
                      id: change.doc.id,
                      map: change.doc.data(),
                    );

                    int index = this
                        .chats
                        .indexWhere((element) => element.chatID == chat.chatID);

                    List<Message> messages = this.chats[index].messages;

                    this.chats[index] = chat;
                    this.chats[index].messages = messages;

                    this
                        .chats
                        .sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

                    notifyListeners();
                  }
                  if (change.type == DocumentChangeType.removed) {
                    Chat chat = Chat.model(
                      ds: change.doc,
                      id: change.doc.id,
                      map: change.doc.data(),
                    );

                    int index = this
                        .chats
                        .indexWhere((element) => element.chatID == chat.chatID);

                    this.chats.removeAt(index);

                    notifyListeners();
                  }
                }),
          onError: (e) => print(e),
        );
  }

  readMoreChats() => this.readChats();

  Future createChat({Chat chat}) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    batch.set(
      this.collection.doc(chat.chatID).collection('messages').doc(),
      chat.recentMessage.map(),
    );
    batch.set(
      this._collection.doc(chat.chatID),
      chat.map(),
    );

    batch.commit();
  }

  Future updateChat({Chat chat}) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    batch.set(
      this.collection.doc(chat.chatID).collection('messages').doc(),
      chat.recentMessage.map(),
    );
    batch.update(
      this.collection.doc(chat.chatID),
      <String, dynamic>{
        'recentMessage': chat.recentMessage.map(),
        'updatedAt': chat.updatedAt,
      },
    );

    batch.commit();
  }

  // Future<List<Message>> prevMessages({Chat chat, int limit = 5}) async {
  //   Query query = chat.messages.isEmpty
  //       ? this
  //           .collection
  //           .doc(chat.chatID)
  //           .collection('messages')
  //           .orderBy('createdAt', descending: true)
  //           .limit(limit)
  //       : this
  //           .collection
  //           .doc(chat.chatID)
  //           .collection('messages')
  //           .orderBy('createdAt', descending: true)
  //           .startAfterDocument(chat.messages.first.ds)
  //           .limit(limit);

  //   return (await query.get())
  //       .docs
  //       .map(
  //         (element) => Message.model(
  //           ds: element,
  //           id: element.id,
  //           map: element.data(),
  //         ),
  //       )
  //       .toList();
  // }

  // Future<List<Message>> missingMessages({Chat chat}) async {
  //   Query query = this
  //       .collection
  //       .doc(chat.chatID)
  //       .collection('messages')
  //       .orderBy('createdAt', descending: false)
  //       .startAfter([chat.messages.last.createdAt]);

  //   return (await query.get())
  //       .docs
  //       .map(
  //         (documentSnapshot) => Message.model(
  //           ds: documentSnapshot,
  //           id: documentSnapshot.id,
  //           map: documentSnapshot.data(),
  //         ),
  //       )
  //       .toList();
  // }

  @override
  void dispose() {
    if (this._chatsStream != null) this._chatsStream.cancel();
    super.dispose();
  }
}
