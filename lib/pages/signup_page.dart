import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterfire/firebase/auth.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _email;
  String _password;
  String _passwordConfirm;
  bool _isLoading;

  @override
  void initState() {
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

  void showError(String message) {
    final snackBar = SnackBar(
      content: Text(message, style: TextStyle(color: Colors.red)),
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

  void signUp() async {
    print("Signing up...");
    setState(() {
      _isLoading = true;
    });

    if (isFormValidated()) {
      if (_password != _passwordConfirm) {
        showError("Password did not matched!");
         setState(() {
            _isLoading = false;
          });
      } else {
        String userId = "";
        try {
          userId = await widget.auth.signUp(_email, _password);
          print('Signed up: $userId');
          setState(() {
            _isLoading = false;
          });
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            SystemNavigator.pop();
          }
        } catch (e) {
          print('Error: $e');
          setState(() {
            _isLoading = false;
          });
          showError(e.message);
        }
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void resetForm() {
    _formKey.currentState.reset();
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
                    padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 20.0),
                    child: new TextFormField(
                      maxLines: 1,
                      obscureText: true,
                      autofocus: false,
                      decoration: new InputDecoration(
                          hintText: null,
                          labelText: 'Confirm Password',
                          hasFloatingPlaceholder: true,
                          icon: new Icon(
                            Icons.lock,
                            color: Colors.grey,
                          )),
                      validator: (value) =>
                          value.isEmpty ? 'Password can\'t be empty' : null,
                      onSaved: (value) => _passwordConfirm = value.trim(),
                    ),
                  ),
                  ButtonTheme(
                    minWidth: double.infinity,
                    child: RaisedButton(
                      onPressed: () => this.signUp(),
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
          title: Text("Sign Up"),
        ),
        body: Stack(
          children: <Widget>[_showCircularProgress(), _showForm()],
        ));
  }
}
