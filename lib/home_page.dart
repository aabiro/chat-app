import 'package:chat_app/chat_page.dart';
import 'package:chat_app/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/providers/chat_provider.dart';
import 'package:provider/provider.dart';

import 'models/message.dart';
import 'models/user.dart';
import 'models/chat.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<User> users = [];
  @override
  void initState() {
    Provider.of<ChatProvider>(context, listen: false).readChats();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var ap = Provider.of<AuthProvider>(context, listen: false);
    var cp = Provider.of<ChatProvider>(context, listen: true);
    var up = Provider.of<UserProvider>(context, listen: false);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            FlatButton(
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async =>
                  await Provider.of<AuthProvider>(context, listen: false)
                      .logout(),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.person)),
              Tab(icon: Icon(Icons.chat)),
            ],
          ),
          title: Text('Chats'),
        ),
        body: TabBarView(
          children: [
            Container(
              child: StreamBuilder<List<User>>(
                stream: up.readUsers(),
                builder: (context, stream) {
                  if (stream.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (stream.hasError) {
                    return Center(child: Text(stream.error.toString()));
                  }

                  this.users = stream.data;

                  return ListView.builder(
                    padding: EdgeInsets.only(left: 25.0, right: 25.0),
                    itemCount: this.users.length,
                    itemBuilder: (context, index) => userItem(
                      user: this.users[index],
                    ),
                  );
                },
              ),
            ),
            Container(
              child: ListView.builder(
                padding: EdgeInsets.only(left: 25.0, right: 25.0),
                shrinkWrap: true,
                itemBuilder: (context, index) => chatItem(
                  chat: cp.chats[index],
                  user: this.users[this.users.indexWhere((element) =>
                      element.userID ==
                      cp.chats[index].users[cp.chats[index].users
                          .indexWhere((element) => element != ap.user.uid)])],
                  isLast: cp.chats.last == cp.chats[index],
                ),
                itemCount: cp.chats.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget userItem({User user}) {
    return GestureDetector(
      child: Container(
        height: 50.0,
        child: Row(
          children: [
            Expanded(
              child: Text(
                user.email,
              ),
            ),
            Text(
              'Say Hello!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      onTap: () async {
        var ap = Provider.of<AuthProvider>(context, listen: false);
        var cp = Provider.of<ChatProvider>(context, listen: false);
        Chat chat;

        if (cp.chats != null)
          for (Chat c in cp.chats) {
            if (c.users.contains(user.userID)) {
              chat = c;
              break;
            }
          }

        if (chat == null) {
          var now = FieldValue.serverTimestamp();

          chat = Chat(
            chatID: cp.collection.doc().id,
            users: [
              ap.user.uid,
              user.userID,
            ],
            recentMessage: Message(
              owner: ap.user.uid,
              msg: 'Hello!',
              createdAt: now,
            ),
            createdAt: now,
            updatedAt: now,
          );

          await cp.createChat(chat: chat);
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              user: user,
              chat: chat,
            ),
            fullscreenDialog: true,
          ),
        );
      },
    );
  }

  Widget chatItem({Chat chat, User user, bool isLast}) {
    return GestureDetector(
      child: Hero(
        tag: chat.chatID,
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            decoration: BoxDecoration(
              // color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
            height: 90.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              user.email,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 2.5,
                            ),
                            Text(
                              chat.recentMessage == null
                                  ? 'Say Hello!'
                                  : chat.recentMessage.msg,
                              style: TextStyle(fontSize: 12.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 2.5,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Divider(
                    thickness: 2.0,
                  ),
              ],
            ),
          ),
        ),
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(
            user: user,
            chat: chat,
          ),
          fullscreenDialog: true,
        ),
      ),
    );
  }
}
