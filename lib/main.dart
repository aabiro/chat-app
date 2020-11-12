import 'package:chat_app/chat_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  // MultiProvider(
  //   providers: [
  //     ChangeNotifierProvider<AuthProvider>(
  //       create: (_) => AuthProvider.instance(),
  //     ),
  //     ChangeNotifierProvider<ChatsProvider>(
  //       create: (_) => ChatsProvider(),
  //     ),
  //   ]
  // )
  // MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(home: LoginPage());
    return MaterialApp(home: ChatListPage());
  }
}
