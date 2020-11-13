import 'dart:async';
import 'package:chat_app/funcs.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/providers/chat_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'models/chat.dart';
import 'models/user.dart';
import 'models/message.dart';

class ChatPage extends StatefulWidget {
  final User user;
  final Chat chat;

  ChatPage({
    Key key,
    this.user,
    this.chat,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // ignore: cancel_subscriptions
  StreamSubscription _streamSubscription;
  ScrollController _scrollController = ScrollController();
  TextEditingController _msgTEC = TextEditingController();
  bool _isFetching = false;
  bool _didFetch = false;

  @override
  void initState() {
    if (widget.chat.messages.isEmpty) {
      this._prevMessages().then((_) {
        this._initMessages();
        this._scrollToBtm();
      });
    } else {
      this._missingMessages().then((_) {
        this._initMessages();
        this._scrollToBtm();
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    if (this._streamSubscription != null) this._streamSubscription.cancel();
    this._scrollController.dispose();
    this._msgTEC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chatting with ${widget.user.email}',
        ),
      ),
      body: Material(
        type: MaterialType.transparency,
        child: Container(
          child: Stack(
            children: [
              GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              ),
              Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await this._prevMessages();
                        return;
                      },
                      child: ListView.builder(
                        reverse: false,
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                          left: 25.0,
                          top: 15.0,
                          right: 25.0,
                          bottom: 15.0,
                        ),
                        itemBuilder: (context, index) => msgItem(
                          context: context,
                          message: widget.chat.messages[index],
                        ),
                        itemCount: widget.chat.messages.length,
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.black,
                    height: 1.0,
                  ),
                  Container(
                    height: 45.0,
                    decoration: BoxDecoration(),
                    margin:
                        EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: buildInputField(
                                  hintText: 'Enter Message',
                                ),
                              ),
                              GestureDetector(
                                child: Icon(Icons.send),
                                onTap: () => this._sendMessage(
                                  context: context,
                                  msg: this._msgTEC.text,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField({String hintText}) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 25.0,
      ),
      child: TextFormField(
        controller: this._msgTEC,
        decoration: InputDecoration(
          labelText: hintText,
          hintStyle: TextStyle(
            color: Color(0xff2196F3),
          ),
        ),
      ),
    );
  }

  Widget dateItem({DateTime dateTime}) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding:
              EdgeInsets.only(bottom: 5.0, top: 5.0, left: 10.0, right: 10.0),
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            DateFormat('MMMM dd').format(dateTime),
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget msgItem({BuildContext context, Message message}) {
    var ap = Provider.of<AuthProvider>(context, listen: false);
    return Column(
      crossAxisAlignment: message.owner == ap.user.uid
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: message.owner == ap.user.uid
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: <Widget>[
            if (message.owner == ap.user.uid)
              Padding(
                padding: EdgeInsets.only(right: 25.0),
                child: Text(
                  DateFormat.jm().format(message.createdAt),
                  style: TextStyle(
                    fontSize: 10.0,
                  ),
                ),
              ),
            Flexible(
              child: Container(
                constraints: BoxConstraints(minHeight: 50.0),
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: message.owner != ap.user.uid
                      ? Colors.grey
                      : Colors.redAccent,
                  border: message.owner != ap.user.uid
                      ? null
                      : Border.all(color: Colors.red),
                  borderRadius: message.owner == ap.user.uid
                      ? BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0),
                          bottomLeft: Radius.circular(25.0),
                        )
                      : BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0),
                          bottomRight: Radius.circular(25.0),
                        ),
                ),
                margin: EdgeInsets.only(
                  bottom: 5.0,
                ),
                child: Column(
                  crossAxisAlignment: message.owner == ap.user.uid
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      message.msg,
                    ),
                  ],
                ),
              ),
            ),
            if (message.owner != ap.user.uid)
              Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: Text(
                  DateFormat.jm().format(message.createdAt),
                  style: TextStyle(
                    fontSize: 10.0,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  _scrollToBtm() {
    if (this._scrollController.hasClients)
      this._scrollController.animateTo(
          this._scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease);
  }

  Future _prevMessages() async {
    if (!this._isFetching && !this._didFetch) {
      if (mounted) setState(() => this._isFetching = true);
      print('Getting Prev Messages...');

      List<Message> messages =
          await Provider.of<ChatProvider>(context, listen: false)
              .prevMessages(chat: widget.chat);

      if (messages != null) {
        int oldCount = widget.chat.messages.length;

        widget.chat.messages.addAll(messages);
        widget.chat.messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

        int newCount = widget.chat.messages.length;

        if (oldCount == newCount) this._didFetch = true;

        if (mounted) setState(() => this._isFetching = false);
      }

      this._scrollToBtm();
      print('Getting Prev Messages Complete.');
    }
  }

  Future _missingMessages() async {
    if (!this._isFetching && !this._didFetch) {
      if (mounted) setState(() => this._isFetching = true);
      print('Getting Missing Messages...');

      List<Message> messages =
          await Provider.of<ChatProvider>(context, listen: false)
              .missingMessages(chat: widget.chat);

      if (messages != null) {
        print('LENGTH');
        print(messages.length);
        int oldCount = widget.chat.messages.length;

        widget.chat.messages.addAll(messages);
        widget.chat.messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

        int newCount = widget.chat.messages.length;

        if (oldCount == newCount) this._didFetch = true;

        if (mounted) setState(() => this._isFetching = false);
      }

      this._scrollToBtm();
      print('Getting Missing Messages Complete.');
    }
  }

  _initMessages() {
    print('Init Live Messages...');
    var cp = Provider.of<ChatProvider>(context, listen: false);

    if (this._streamSubscription != null) this._streamSubscription.cancel();

    Query query = widget.chat.messages.isEmpty
        ? cp.collection
            .doc(widget.chat.chatID)
            .collection('messages')
            .orderBy('createdAt', descending: false)
        : cp.collection
            .doc(widget.chat.chatID)
            .collection('messages')
            .orderBy('createdAt', descending: false)
            .startAfter([widget.chat.recentMessage.createdAt]);

    this._streamSubscription = query.snapshots().listen(
          (event) => event.docs.isEmpty
              ? () {}
              : event.docChanges.forEach((change) {
                  if (change.type == DocumentChangeType.added) {
                    Message m = Message.model(
                        ds: change.doc,
                        id: change.doc.id,
                        map: change.doc.data());
                    if (mounted)
                      setState(() {
                        widget.chat.messages.add(m);
                        widget.chat.messages
                            .sort((a, b) => a.createdAt.compareTo(b.createdAt));
                        this._scrollToBtm();
                      });
                  }
                  if (change.type == DocumentChangeType.modified) {}
                  if (change.type == DocumentChangeType.removed) {}
                }),
          onError: (e) => print(e),
        );
  }

  Future _sendMessage({BuildContext context, String msg}) async {
    if (msg.trim().isEmpty) return;

    var ap = Provider.of<AuthProvider>(context, listen: false);
    var cp = Provider.of<ChatProvider>(context, listen: false);

    var now = FieldValue.serverTimestamp();

    Chat chat = Chat(
      chatID: widget.chat.chatID,
      users: [
        widget.user.userID,
        ap.user.uid,
      ],
      recentMessage: Message(
        owner: ap.user.uid,
        msg: msg,
        createdAt: now,
      ),
      createdAt: now,
      updatedAt: now,
    );

    await cp
        .updateChat(
      chat: chat,
    )
        .then((value) async {
      // Funcs.notifyUserOf(
      //     functionName: 'chatNotification',
      //     data: <String, dynamic>{
      //       'toUserID': widget.user.userID,
      //       'fromUserEmail': ap.user.email,
      //       'chatID': widget.chat.chatID,
      //     });
      if (mounted)
        setState(() {
          this._msgTEC.text = '';
          this._scrollToBtm();
        });
    });
  }
}
