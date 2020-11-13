import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email, pass;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 50),
              this.buildInputField(hintText: 'Email'),
              this.buildInputField(hintText: 'Password', obsecure: true),
              SizedBox(height: 25),
              _loginButton(context),
              _registerButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField({
    String hintText,
    bool obsecure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 25.0),
      child: TextFormField(
        obscureText: obsecure,
        decoration: InputDecoration(
          labelText: hintText,
          hintStyle: TextStyle(
            color: Color(0xff2196F3),
          ),
        ),
        onChanged: (s) => obsecure ? this.pass = s : this.email = s,
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 25.0),
      child: OutlineButton(
        onPressed: () async =>
            await Provider.of<AuthProvider>(context, listen: false)
                .login(email: this.email, password: this.pass),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("Login"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _registerButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 25.0),
      child: OutlineButton(
        onPressed: () async =>
            await Provider.of<AuthProvider>(context, listen: false)
                .register(email: this.email, password: this.pass)
                .then(
                  (user) async =>
                      await Provider.of<UserProvider>(context, listen: false)
                          .createUser(
                    uid: user.uid,
                    email: this.email,
                  ),
                ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
