import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './dinner.dart';

class Dinners with ChangeNotifier {
  List<Dinner> _loadedDinners = [];
  String uid = '';

  void setUid(String id) {
    this.uid = id;
  }

  final databaseReference = Firestore.instance;

  List<Dinner> get personal {
    final pers =
        _loadedDinners.where((element) => element.creatorId == uid).toList();
    return pers;
  }

  List<Dinner> get items {
    return [..._loadedDinners];
  }

  Dinner findDinnerById(String id) {
    return _loadedDinners.firstWhere((recipe) => recipe.id == id);
  }

  Future<void> fetchAndSetDinners(userlat, userlon) async {
    await databaseReference
        .collection("dinner")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      List<Dinner> docs = [];
      snapshot.documents.forEach((element) {
        docs.add(
            Dinner.fromMap(element.data, element.documentID, userlat, userlon));
      });
      docs.sort((a, b) => a.dist.compareTo(b.dist));

      _loadedDinners = docs;
    });
  }

  Future addDinner(Dinner data) async {
    _loadedDinners.add(data);
    var result =
        await databaseReference.collection("dinner").add(data.toJson());
    notifyListeners();
    return result;
  }

  Future removeDinner(Dinner data) async {
    _loadedDinners.remove(data);
    var result =
        await databaseReference.collection("dinner").document(data.id).delete();
    notifyListeners();
    return result;
  }

  Future updateDinner(String id, Map data) async {
    var result =
        await databaseReference.collection("dinner").document(id).setData(data);
    return result;
  }
}
