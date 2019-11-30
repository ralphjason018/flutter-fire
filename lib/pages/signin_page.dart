import 'package:flutter/material.dart';
import 'package:flutterfire/firebase/auth.dart';

class SignInPage extends StatefulWidget {
  SignInPage({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _email;
  String _password;
  String _errorMessage;
  bool _isLoading;

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  bool isFormValidated() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void signIn() async {
    print("Signing in...");
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });

    if (isFormValidated()) {
      String userId = "";
      try {
        userId = await widget.auth.signIn(_email, _password);
        print('Signed in: $userId');
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
        });
        final snackBar = SnackBar(
          content: Text(e.message, style: TextStyle(color: Colors.red)),
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {
              _formKey.currentState.reset();
            },
          ),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    }
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _showForm() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
          padding: EdgeInsets.all(25.0),
          child: Form(
              key: _formKey,
              child: new Column(
                children: <Widget>[
                  Image(
                    image: AssetImage('lib/assets/logo.png'),
                    height: 200,
                    width: 200,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    child: new TextFormField(
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      autofocus: false,
                      decoration: new InputDecoration(
                          hintText: null,
                          labelText: 'Email',
                          hasFloatingPlaceholder: true,
                          icon: new Icon(
                            Icons.mail,
                            color: Colors.grey,
                          )),
                      validator: (value) =>
                          value.isEmpty ? 'Email can\'t be empty' : null,
                      onSaved: (value) => _email = value.trim(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 20.0),
                    child: new TextFormField(
                      maxLines: 1,
                      obscureText: true,
                      autofocus: false,
                      decoration: new InputDecoration(
                          hintText: null,
                          labelText: 'Password',
                          hasFloatingPlaceholder: true,
                          icon: new Icon(
                            Icons.lock,
                            color: Colors.grey,
                          )),
                      validator: (value) =>
                          value.isEmpty ? 'Password can\'t be empty' : null,
                      onSaved: (value) => _password = value.trim(),
                    ),
                  ),
                  ButtonTheme(
                    minWidth: double.infinity,
                    child: RaisedButton(
                      onPressed: () => this.signIn(),
                      child: Text('Sign In'),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text("Don't have an account yet?")),
                  ButtonTheme(
                    buttonColor: Colors.white,
                    minWidth: double.infinity,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: Text('Sign Up'),
                    ),
                  ),
                ],
              ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Sign In"),
        ),
        body: Stack(
          children: <Widget>[_showCircularProgress(), _showForm()],
        ));
  }
}
