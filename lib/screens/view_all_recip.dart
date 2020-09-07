import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/services/recipes.dart';
import 'package:flutter_complete_guide/widgets/row_recipe.dart';
import 'package:provider/provider.dart';

class ViewAllScreen extends StatelessWidget {
  static const routeName = '/view-all';
  @override
  Widget build(BuildContext context) {
    final recipes = Provider.of<Recipes>(context).items;
    return Scaffold(
        body: Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 48.0),
        child: Row(children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            iconSize: 30,
            color: Colors.black,
            onPressed: () => Navigator.pop(context),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 100.0),
            child: Text(
              "ALL RECIPES",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ]),
      ),
      Container(
          height: MediaQuery.of(context).size.height - 100,
          child: ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (ctx, i) {
                String id = recipes[i].id;
                return RecipeRow(id.toString());
              }))
    ]));
  }
}
