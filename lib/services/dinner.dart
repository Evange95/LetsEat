import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong/latlong.dart';

class Dinner with ChangeNotifier {
  String id;
  String creatorId;
  String title;
  String description;
  String imageUrl;
  double price;
  int maxNum;
  Timestamp date;
  List<dynamic> participants = [];
  String address;
  String lat;
  String lon;
  double dist;
  List<dynamic> dishes;

  Dinner(
      {this.id,
      this.creatorId,
      this.address,
      this.description,
      this.dishes,
      this.imageUrl,
      this.lat,
      this.lon,
      this.maxNum,
      this.participants,
      this.price,
      this.date,
      this.title});

  static double distance(lat1, lat2, lon1, lon2) {
    final Distance distance = new Distance();

    return distance.as(
        LengthUnit.Kilometer, new LatLng(lat1, lon1), new LatLng(lat2, lon2));
  }

  Dinner.fromMap(Map snapshot, String id, userlat, userlon)
      : this.id = id,
        this.address = snapshot['address'],
        this.creatorId = snapshot['creatorId'],
        this.description = snapshot['description'],
        this.imageUrl = snapshot['imageUrl'],
        this.title = snapshot['title'],
        this.dishes = snapshot['dishes'],
        this.lon = snapshot['lon'],
        this.lat = snapshot['lat'],
        this.maxNum = snapshot['max_num'],
        this.dist = distance(
            double.parse(snapshot['lat']),
            double.parse(userlat),
            double.parse(snapshot['lon']),
            double.parse(userlon)),
        this.participants = snapshot['participants'],
        this.price = snapshot['price'],
        this.date = snapshot['date'];

  toJson() {
    return {
      "address": this.address,
      "dishes": this.dishes,
      "creatorId": this.creatorId,
      "description": this.description,
      "imageUrl": this.imageUrl,
      "title": this.title,
      "lon": this.lon,
      "lat": this.lat,
      "max_num": this.maxNum,
      "participants": this.participants,
      "price": this.price,
      "date": this.date,
    };
  }

  final databaseReference = Firestore.instance;

  Future<void> addremovePartecipant(String personid) async {
    if (participants.contains(personid)) {
      participants.remove(personid);
    } else
      participants.add(personid);
    notifyListeners();

    try {
      await databaseReference
          .collection('dinner')
          .document(id)
          .updateData({'participants': participants});
    } catch (e) {
      print(e);
    }
  }
}
