import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/home/home.dart';
import 'package:flutter_complete_guide/services/user.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CompleteProfileScreen extends StatefulWidget {
  static const routeName = '/complete-pref';
  @override
  _CompleteProfileScreenState createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  double apert = 5;
  double first = 5;
  double main = 5;
  double side = 5;
  double dessert = 5;

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User>(context);
    final _uid = Provider.of<FirebaseUser>(context).uid;

    Future<void> setValues(
      double a,
      double f,
      double m,
      double s,
      double d,
    ) async {
      double sum = a + f + m + s + d;
      final data = {
        'preferences': [
          a / sum,
          f / sum,
          m / sum,
          s / sum,
          d / sum,
        ],
        'complete': true
      };
      try {
        final result = await _user.setUserData(_uid, data);
        var url = 'http://bascio93.pythonanywhere.com//list?a=$_uid';
        var response = await http.get(url);
        print(response);
        return result;
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
        body: SafeArea(
      child: ListView(padding: EdgeInsets.all(8), children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 90),
          child: Text(
            'Insert for each type of dish your preferecies',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 30),
          child: Text(
            'Apertizer',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Slider(
          min: 0,
          max: 10,
          value: apert,
          divisions: 10,
          label: '$apert',
          onChanged: (double val) {
            setState(() {
              apert = val;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 30),
          child: Text(
            'First Dish',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Slider(
          min: 0,
          max: 10,
          value: first,
          divisions: 10,
          label: '$first',
          onChanged: (double val) {
            setState(() {
              first = val;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 30),
          child: Text(
            'Main Dish',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Slider(
          min: 0,
          max: 10,
          value: main,
          divisions: 10,
          label: '$main',
          onChanged: (double val) {
            setState(() {
              main = val;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 30),
          child: Text(
            'Side Dish',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Slider(
          min: 0,
          max: 10,
          value: side,
          divisions: 10,
          label: '$side',
          onChanged: (double val) {
            setState(() {
              side = val;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 30),
          child: Text(
            'Dessert',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Slider(
          min: 0,
          max: 10,
          value: dessert,
          divisions: 10,
          label: '$dessert',
          onChanged: (double val) {
            setState(() {
              dessert = val;
            });
          },
        ),
        Center(
          child: RaisedButton(
              color: Colors.green,
              child: Text(
                'Save you preferences!',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () async {
                await setValues(apert, first, main, side, dessert).then(
                    (value) => Navigator.of(context)
                        .pushReplacementNamed(Home.routeName));
              }),
        ),
      ]),
    ));
  }
}
