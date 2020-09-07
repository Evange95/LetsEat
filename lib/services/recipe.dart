import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe with ChangeNotifier {
  String id;
  String creatorId;
  bool isFavorite = false;
  bool isdone = false;
  String title;
  String description;
  String imageUrl;
  List<dynamic> ingredients;
  List<dynamic> steps;
  int duration;
  String complexity;
  String affordability;
  List<dynamic> comments = [];
  String type;
  final databaseReference = Firestore.instance;

  Recipe({
    this.id,
    @required this.title,
    this.isdone = false,
    this.isFavorite = false,
    this.comments,
    @required this.creatorId,
    @required this.description,
    @required this.imageUrl,
    @required this.ingredients,
    @required this.steps,
    @required this.duration,
    @required this.complexity,
    @required this.affordability,
    @required this.type,
  });

  Recipe.fromMap(
      Map snapshot, String id, List<dynamic> userfav, List<dynamic> userDone)
      : this.affordability = snapshot['affordabilty'],
        this.complexity = snapshot['complexity'],
        this.creatorId = snapshot['creatorId'],
        this.description = snapshot['description'],
        this.imageUrl = snapshot['imageUrl'],
        this.title = snapshot['title'],
        this.id = id.toString(),
        this.steps = snapshot['steps'],
        this.comments =
            snapshot['comments'] != null ? snapshot['comments'] : [],
        this.type = snapshot['type'],
        this.ingredients = snapshot['ingredients'],
        this.duration = snapshot['duration'],
        this.isFavorite = userfav.contains(id) ? true : false,
        this.isdone = userDone.contains(id) ? true : false;

  toJson() {
    return {
      "affordabilty": this.affordability,
      "complexity": this.complexity,
      "creatorId": this.creatorId,
      "description": this.description,
      "imageUrl": this.imageUrl,
      "title": this.title,
      'comments': this.comments,
      "id": this.id,
      "type": this.type,
      "steps": this.steps,
      "ingredients": this.ingredients,
      "duration": this.duration,
    };
  }

  Future<void> toggleFavoriteStatus(List<dynamic> userfav, String uid) async {
    isFavorite = !isFavorite;

    try {
      if (isFavorite) {
        userfav.add(this.id);
      } else {
        if (userfav.contains(this.id)) {
          userfav.remove(this.id);
        }
      }
      await databaseReference
          .collection('users')
          .document(uid)
          .updateData({'favourites': userfav});
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<void> toggleDoneStatus(List<dynamic> userDone, String uid) async {
    isdone = !isdone;
    notifyListeners();

    try {
      if (isdone) {
        userDone.add(this.id);
      } else {
        if (userDone.contains(this.id)) {
          userDone.remove(this.id);
        }
      }
      await databaseReference
          .collection('users')
          .document(uid)
          .updateData({'done': userDone});
    } catch (e) {
      print(e);
    }
  }

  Future<void> addComment(comm) async {
    comments.add(comm);
    try {
      await Firestore.instance
          .collection('recipes')
          .document(id)
          .updateData({'comments': comments});
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }
}
