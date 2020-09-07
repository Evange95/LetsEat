import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User with ChangeNotifier {
  String uid;
  String email;
  String name;
  String surname;
  String address;
  String city;
  String civicnumber;
  String lat;
  String lon;
  bool complete;
  List<dynamic> favourites = [];
  List<dynamic> dinners = [];
  List<dynamic> done = [];
  List<dynamic> suggested = [];
  List<dynamic> preferences = [];

  final CollectionReference userDb = Firestore().collection('users');

  Future<void> getUserData(userid) async {
    uid = userid;
    final result =
        await userDb.document(uid).get().then((DocumentSnapshot document) {
      email = document.data['email'];
      name = document.data['name'];
      surname = document.data['surname'];
      address = document.data['address'];
      lat = document.data['lat'];
      lon = document.data['lon'];
      city = document.data['city'];
      civicnumber = document.data['civicnumber'];
      favourites = document.data['favourites'];
      dinners = document.data['dinners'];
      done = document.data['done'];
      suggested = document.data['suggested'];
      complete = document.data['complete'];
      preferences = document.data['preferences'];
    });
    return result;
  }

  Future<void> setUserData(uid, data) async {
    return await userDb.document(uid).updateData(data);
  }

  Future<void> addRemoveDinner(uid, idDinner) async {
    if (dinners.contains(idDinner)) {
      dinners.remove(idDinner);
    } else {
      dinners.add(idDinner);
    }
    notifyListeners();

    try {
      await userDb.document(uid).updateData({'dinners': dinners});
    } catch (e) {
      print(e);
    }
  }
}
