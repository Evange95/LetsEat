import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_complete_guide/screens/comment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/services/recipes.dart';
import 'package:flutter_complete_guide/services/user.dart';

import 'package:provider/provider.dart';

class ColumnBuilder extends StatelessWidget {
  final IndexedWidgetBuilder itemBuilder;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection textDirection;
  final VerticalDirection verticalDirection;
  final int itemCount;

  const ColumnBuilder({
    Key key,
    @required this.itemBuilder,
    @required this.itemCount,
    this.mainAxisAlignment: MainAxisAlignment.center,
    this.mainAxisSize: MainAxisSize.max,
    this.crossAxisAlignment: CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection: VerticalDirection.down,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: new List.generate(
          this.itemCount, (index) => this.itemBuilder(context, index)).toList(),
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}

class RecipeDetailScreen extends StatefulWidget {
  static const routeName = '/recipe-detail';
  final String id;
  RecipeDetailScreen(this.id);

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  Widget build(BuildContext context) {
    // ignore: unused_element
    void _showErrorDialog(String message) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Cannot comment right now'),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }

    final recipe = Provider.of<Recipes>(context).findRecipeById(widget.id);
    bool isloading = false;
    final user = Provider.of<User>(context);
    final uid = Provider.of<FirebaseUser>(context).uid;
    //Need to get all the data

    return Scaffold(
      appBar: AppBar(
        actions: [
          if (recipe.creatorId != uid)
            RaisedButton.icon(
              onPressed: () {
                recipe.toggleDoneStatus(user.done, uid);
                setState(() {});
              },
              icon: Icon(
                recipe.isdone ? Icons.done : Icons.not_interested,
              ),
              label: recipe.isdone ? Text('Done') : Text('Not Done'),
              color: Colors.orange,
            ),
          if (recipe.creatorId != uid)
            RaisedButton.icon(
              onPressed: () {
                setState(() {
                  isloading = true;
                });
                recipe.toggleFavoriteStatus(user.done, uid).then((value) {
                  if (recipe.isFavorite)
                    Provider.of<Recipes>(context).addFav(recipe);
                  else
                    Provider.of<Recipes>(context).removeFav(recipe);
                  setState(() {
                    isloading = false;
                  });
                });
              },
              icon: Icon(
                  recipe.isFavorite ? Icons.favorite : Icons.favorite_border),
              label: recipe.isFavorite ? Text('Fav') : Text('Not Fav'),
              color: Colors.orange,
            ),
          RaisedButton.icon(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(CommentScreen.routeName, arguments: recipe);
            },
            icon: Icon(Icons.comment),
            label: Text('Comment'),
            color: Colors.orange,
          )
        ],
      ),
      body: isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: ListView(
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 80.0),
                        child: Container(
                          height: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0.0, 2.0),
                                    blurRadius: 6.0)
                              ]),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Image(
                                image: NetworkImage(recipe.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    recipe.title,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.timer,
                              size: 30,
                            ),
                            Text(
                              '${recipe.duration.toString()} min',
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.monetization_on,
                              size: 30,
                            ),
                            Text(
                              '${recipe.affordability}',
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bookmark_border,
                        size: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${recipe.type.toUpperCase()} Course',
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Description",
                              style: TextStyle(
                                  fontSize: 23, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              '${recipe.description}',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "What do you need:",
                              style: TextStyle(
                                  fontSize: 23, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            ColumnBuilder(
                                itemCount: recipe.ingredients.length,
                                itemBuilder: (BuildContext context, int index) {
                                  String step = recipe.ingredients[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '$step',
                                      style: TextStyle(fontSize: 20),
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "How to make it:",
                              style: TextStyle(
                                  fontSize: 23, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            ColumnBuilder(
                                itemCount: recipe.steps.length,
                                itemBuilder: (BuildContext context, int index) {
                                  String step = recipe.steps[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${index + 1}) $step',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
