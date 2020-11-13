import 'package:chat_app/home_page.dart';
import 'package:chat_app/login_page.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/providers/chat_provider.dart';
import 'package:chat_app/providers/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider.instance(),
        ),
        ChangeNotifierProvider<ChatProvider>(
          create: (_) => ChatProvider(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget view;

    switch (Provider.of<AuthProvider>(context).status) {
      case AuthStatus.Null:
        view = Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
        break;
      case AuthStatus.Authenticated:
        view = HomePage();
        break;
      case AuthStatus.Unauthenticated:
        view = LoginPage();
        break;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: view,
    );
  }
}
