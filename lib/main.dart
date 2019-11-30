import 'package:flutter/material.dart';
import 'package:flutterfire/pages/home_page.dart';
import 'package:flutterfire/pages/root_page.dart';
import 'package:flutterfire/pages/signin_page.dart';
import 'package:flutterfire/pages/signup_page.dart';

import 'firebase/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
        ),
        home: new RootPage(auth: new Auth()),
        routes: <String, WidgetBuilder>{
          '/signin': (BuildContext context) => new SignInPage(),
          '/signup': (BuildContext context) => new SignUpPage(auth: new Auth()),
          '/home': (BuildContext context) => new HomePage(),
        });
  }
}
