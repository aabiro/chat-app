import 'package:flutter/material.dart';

class ChatListPage extends StatefulWidget {
  ChatListPage({Key key}) : super(key: key);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        child: Scaffold(
          // isOn: true,
          // includePadding: false,
          // title: 'Chats',
          // child: (context, theme, cameras, network, jsons, auth, chats, child) => 
          
          body: ListView(
            // controller: this._scrollController,
            // physics: Config.scrollPhysics,
            children: <Widget>[
              // SectionTitle(
              //   title: 'Connections',
              // ),
              // MatchedList(
              //   users: auth.connection == null
              //       ? []
              //       : auth.connection.matches
              //           .where((m) => chats.chats.indexWhere((c) => c.users.contains(m.userID)) == -1)
              //           .toList(),
              // ),
              // SectionTitle(
              //   title: 'Conversations',
              // ),
              // Padding(
              //   padding: EdgeInsets.only(left: 20, right: 20),
              //   child: ListView(
              //     physics: NeverScrollableScrollPhysics(),
              //     shrinkWrap: true,
              //     children: List.generate(
              //       chats.chats.length,
              //       (index) => ChatItem(
              //         // key: Key(chats.chats[index].chatID),
              //         chat: chats.chats[index],
              //         isLast: chats.chats.last == chats.chats[index],
              //       ),
              //     ),
              //   ),
              // ),
              // this._isLoading
              //     ? Container(
              //         padding: const EdgeInsets.only(bottom: 25.0),
              //         height: 100.0,
              //         child: PAIndicator(),
              //       )
              //     : chats.chats.isEmpty
              //         ? Container(
              //             padding: const EdgeInsets.only(bottom: 25.0),
              //             height: 100.0,
              //             child: Center(
              //               child: Text(
              //                 'See the message? Means you didn\'t\napply to enough jobs... GET TO IT!',
              //                 textAlign: TextAlign.center,
              //               ),
              //             ),
              //           )
              //         : Container(),
            ],
          ),
        ),
      );
  }
