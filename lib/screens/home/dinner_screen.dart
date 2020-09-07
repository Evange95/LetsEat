//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/services/dinners.dart';
import 'package:flutter_complete_guide/services/user.dart';
import 'package:flutter_complete_guide/widgets/dinner_row.dart';
import 'package:provider/provider.dart';

class DinnerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dinners = Provider.of<Dinners>(context).items;
    return Scaffold(
        body: SafeArea(
      child: Column(children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 19.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 120),
                child: Text(
                  'LetsMeet Too!',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 120),
                child: Text(
                  'Here you can find some dinners of your intereset',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                  height: MediaQuery.of(context).size.height - 250,
                  child: ListView.builder(
                      itemCount: dinners.length,
                      itemBuilder: (ctx, i) {
                        String id = dinners[i].id;
                        String uid = Provider.of<User>(context).uid;
                        return dinners[i].creatorId == uid
                            ? SizedBox(
                                height: 0,
                              )
                            : DinnerRow(id.toString());
                      }))
            ],
          ),
        ),
      ]),
    ));
  }
}
