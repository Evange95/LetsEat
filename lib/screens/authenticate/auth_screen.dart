import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/services/auth.dart';
import '../../models/http_exception.dart';

enum AuthMode { Signup, Login, Reset }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(136, 176, 75, 1).withOpacity(0.5),
                  Color.fromRGBO(214, 80, 118, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'LetsEat',
                        style: TextStyle(
                          color:
                              Theme.of(context).accentTextTheme.headline6.color,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;

  AuthService _auth = AuthService();

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await _auth.loginWithEmailAndPassword(
          _authData['email'].trim(),
          _authData['password'].trim(),
        );
      } else {
        // Sign user up
        await _auth.registerWithEmailAndPassword(
          _authData['email'].trim(),
          _authData['password'].trim(),
        );
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error
          .toString()
          .contains('User already Signed Up with Google')) {
        errorMessage =
            'User already Signed Up with Google, Please login with the google button';
      } else if (error.toString().contains(
          'User already Signed Up with Email and Password. Please Login with them')) {
        errorMessage =
            'User already Signed Up with Email and Password. Please Login with them';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      var errorMessage = error != null
          ? error
          : 'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _googleSubmit() async {
    try {
      await _auth.signInWithGoogle();
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      var errorMessage = '';
      print(error);
      if (error !=
          'User already Signed Up with Email and Password. Please Login with them')
        errorMessage = 'Could not authenticate you. Please try again later.';
      else
        errorMessage = error;
      _showErrorDialog(errorMessage);
    }
  }

  Future<void> _resetPassword() async {
    try {
      await _auth.resetpassword(_authData['email'].trim()).then((value) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Check your email'),
            content: Text(
                'An email with the reset link has been sent to ${_authData['email'].trim()}'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      });
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error
          .toString()
          .contains('User already Signed Up with Google')) {
        errorMessage =
            'User already Signed Up with Google, Please login with the google button';
      } else if (error.toString().contains(
          'User already Signed Up with Email and Password. Please Login with them')) {
        errorMessage =
            'User already Signed Up with Email and Password. Please Login with them';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      var errorMessage = '';
      print(error);
      if (error !=
          'User already Signed Up with Email and Password. Please Login with them')
        errorMessage = 'Could not authenticate you. Please try again later.';
      else
        errorMessage = error;
      _showErrorDialog(errorMessage);
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.Signup ? 400 : 350,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 400 : 300),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(labelText: 'E-Mail'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value.isEmpty || !value.contains('@')) {
                            return 'Invalid email!';
                          } else
                            return null;
                        },
                        onSaved: (value) {
                          _authData['email'] = value;
                        },
                      ),
                      if (_authMode == AuthMode.Login ||
                          _authMode == AuthMode.Signup)
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          controller: _passwordController,
                          validator: (value) {
                            if (value.isEmpty || value.length < 5) {
                              return 'Password is too short!';
                            } else
                              return null;
                          },
                          onSaved: (value) {
                            _authData['password'] = value;
                          },
                        ),
                      if (_authMode == AuthMode.Signup)
                        TextFormField(
                          enabled: _authMode == AuthMode.Signup,
                          decoration:
                              InputDecoration(labelText: 'Confirm Password'),
                          obscureText: true,
                          validator: _authMode == AuthMode.Signup
                              ? (value) {
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match!';
                                  } else
                                    return null;
                                }
                              : null,
                        ),
                      if (_authMode == AuthMode.Login)
                        FlatButton(
                          child: Text('Reset Password'),
                          onPressed: () {
                            setState(() {
                              _authMode = AuthMode.Reset;
                            });
                          },
                        ),
                      SizedBox(
                        height: 20,
                      ),
                      if (_isLoading)
                        null
                      else if (_authMode != AuthMode.Reset)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _signInButton(),
                            _googleSignInButton(),
                          ],
                        ),
                      if (_authMode == AuthMode.Reset)
                        Column(
                          children: <Widget>[
                            _resetButton(),
                            FlatButton(
                              child: Text(
                                'Back to Login',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.green),
                              ),
                              onPressed: () {
                                setState(() {
                                  _authMode = AuthMode.Login;
                                });
                              },
                            )
                          ],
                        ),
                      SizedBox(
                        height: 17,
                      ),
                      if (_authMode != AuthMode.Reset)
                        FlatButton(
                          child: Text(
                            '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD',
                            style: TextStyle(fontSize: 14),
                          ),
                          onPressed: _switchAuthMode,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 4),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          textColor: Theme.of(context).primaryColor,
                        ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _googleSignInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: _googleSubmit,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
                image: AssetImage("lib/assets/google_logo.png"), height: 30.0),
          ],
        ),
      ),
    );
  }

  Widget _signInButton() {
    return OutlineButton(
        splashColor: Colors.blue,
        onPressed: _submit,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        highlightElevation: 0,
        borderSide: BorderSide(color: Colors.grey),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Text(
            _authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP',
            style: TextStyle(
              fontSize: 15,
              color: Colors.blue,
            ),
          ),
        ));
  }

  Widget _resetButton() {
    return OutlineButton(
        splashColor: Colors.blue,
        onPressed: () {
          _resetPassword().then((value) {
            setState(() {
              _authMode = AuthMode.Login;
            });
          });
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        highlightElevation: 5,
        borderSide: BorderSide(color: Colors.grey),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Text(
            'RESET PASSWORD',
            style: TextStyle(
                fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ));
  }
}
