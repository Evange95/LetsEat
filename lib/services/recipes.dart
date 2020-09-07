//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './recipe.dart';

class Recipes with ChangeNotifier {
  List<Recipe> _loadedRecipes = [];
  List<Recipe> _favourites = [];

  String uid = '';

  void setUid(String id) {
    this.uid = id;
  }

  final databaseReference = Firestore.instance;

  List<Recipe> get suggested {
    final List shuff = new List<Recipe>.from(_loadedRecipes);
    shuff.shuffle();
    return [...shuff];
  }

  List<Recipe> get personal {
    final pers =
        _loadedRecipes.where((element) => element.creatorId == uid).toList();
    return pers;
  }

  List<Recipe> get items {
    return [..._loadedRecipes];
  }

  List<Recipe> get fav {
    return [..._favourites];
  }

  Recipe findRecipeById(String id) {
    return _loadedRecipes.firstWhere((recipe) => recipe.id == id);
  }

  Future<void> fetchAndSetRecipes(
      List<dynamic> userfav, List<dynamic> userdone) async {
    await databaseReference
        .collection("recipes")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      List<Recipe> docs = [];
      snapshot.documents.forEach((element) {
        docs.add(Recipe.fromMap(
            element.data, element.documentID, userfav, userdone));
      });
      _loadedRecipes = docs;
      _favourites = _loadedRecipes
          .where((element) => element.isFavorite == true)
          .toList();
    });
  }

  void addFav(Recipe recipe) {
    return _favourites.add(recipe);
  }

  bool removeFav(Recipe recipe) {
    return _favourites.remove(recipe);
  }

  Future addRecipe(Recipe data) async {
    _loadedRecipes.add(data);
    var result =
        await databaseReference.collection("recipes").add(data.toJson());
    notifyListeners();
    return result;
  }

  Future removeRecipe(Recipe data) async {
    _loadedRecipes.remove(data);
    var result = await databaseReference
        .collection("recipes")
        .document(data.id)
        .delete();
    notifyListeners();
    return result;
  }

  Future updateRecipe(String id, Map data) async {
    var result = await databaseReference
        .collection("recipes")
        .document(id)
        .setData(data);
    return result;
  }

  List<Recipe> userRecipes() {
    return _loadedRecipes.where((data) => data.creatorId == uid).toList();
  }
}
