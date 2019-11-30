import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire/firebase/auth.dart';
import 'package:flutterfire/pages/home_page.dart';
import 'package:flutterfire/pages/signin_page.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: widget.auth.checkAuthStatus(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return new HomePage(auth: widget.auth);
        } else {
          return new SignInPage(auth: widget.auth);
        }
      },
    );
  }
}
