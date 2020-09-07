import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_complete_guide/screens/authenticate/auth_screen.dart';
import 'package:flutter_complete_guide/screens/complete_user.dart';
import 'package:flutter_complete_guide/screens/home/home.dart';
import 'package:flutter_complete_guide/services/recipes.dart';
import 'package:flutter_complete_guide/services/user.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  static const routeName = '/wrapper';
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);

    if (user == null) {
      return AuthScreen();
    } else {
      Provider.of<Recipes>(context).setUid(user.uid);
      return FutureBuilder<void>(
        future: Provider.of<User>(context, listen: false)
            .getUserData(user.uid), // a Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            default:
              if (snapshot.hasError) {
                Firestore().collection('users').document(user.uid).setData({
                  'email': user.email,
                  'favourites': [],
                  'done': [],
                  'dinners': [],
                  'suggested': [],
                  'complete': false
                });

                return CompleteUser();
              } else {
                bool complete = Provider.of<User>(context).complete;
                if (complete == true) {
                  return Home();
                } else {
                  return CompleteUser();
                }
              }
          }
        },
      );
    }
  }
}
