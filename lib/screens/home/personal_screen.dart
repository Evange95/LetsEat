import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/services/auth.dart';
import 'package:flutter_complete_guide/services/user.dart';
import 'package:flutter_complete_guide/widgets/carousel.dart';
import 'package:provider/provider.dart';

class PersonalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthService _auth = AuthService();
    var user = Provider.of<User>(context);
    return Scaffold(
        body: SafeArea(
            child: ListView(
                padding: EdgeInsets.symmetric(vertical: 30.0),
                children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 120),
            child: Text(
              'Hey ${user.name}!',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          Carousel(type: 'fav'),
          Carousel(type: 'per'),
          Carousel(type: 'din'),
          RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.red)),
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            color: Colors.red,
            onPressed: () {
              _auth
                  .signOut(); //.then((value) =>  Navigator.of(context).pushReplacementNamed(Wrapper.routeName));
            },
          ),
        ])));
  }
}
