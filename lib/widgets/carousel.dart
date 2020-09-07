import 'package:flutter_complete_guide/screens/add_dinner_screen.dart';
import 'package:flutter_complete_guide/screens/add_recipe_screen.dart';
import 'package:flutter_complete_guide/screens/dinner_detail_screen.dart';
import 'package:flutter_complete_guide/screens/edit_dinner_screen.dart';
import 'package:flutter_complete_guide/screens/edit_recipe_screen.dart';
import 'package:flutter_complete_guide/screens/recipe_detail_screen.dart';
import 'package:flutter_complete_guide/screens/view_all_recip.dart';
import 'package:flutter_complete_guide/services/dinners.dart';
import 'package:flutter_complete_guide/services/user.dart';
import '../services/recipes.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  final String type;

  Carousel({this.type});

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> recipes = [];
    var string = '';
    if (widget.type == 'top') {
      recipes = Provider.of<Recipes>(context).items;
      string = 'Top';
    }
    if (widget.type == 'suggested') {
      recipes = [];
      Provider.of<User>(context).suggested.forEach((element) {
        recipes.add(Provider.of<Recipes>(context).findRecipeById(element));
      });
      string = 'Suggested';
    }
    if (widget.type == 'fav') {
      recipes = Provider.of<Recipes>(context).fav;
      string = 'Favourite Recipes';
    }
    if (widget.type == 'per') {
      recipes = Provider.of<Recipes>(context).personal;
      string = 'Personal Recipes';
    }
    if (widget.type == 'din') {
      recipes = Provider.of<Dinners>(context).personal;
      string = 'Your Dinners';
    }

    void _showdeletedialog(id) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Do you need help?'),
          content: Text('Are you sure you want to delete it?'),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                var doc = widget.type == 'din'
                    ? Provider.of<Dinners>(context).findDinnerById(id)
                    : Provider.of<Recipes>(context).findRecipeById(id);
                if (widget.type == 'din') {
                  Provider.of<Dinners>(context).removeDinner(doc);
                } else {
                  Provider.of<Recipes>(context).removeRecipe(doc);
                }
                setState(() {});
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                string,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1),
              ),
              if (widget.type == 'top')
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      'See all',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(ViewAllScreen.routeName);
                  },
                ),
              if (widget.type == 'per')
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      "Add a recipe",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(AddRecipeScreen.routeName);
                  },
                ),
              if (widget.type == 'din')
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      'Organize a Dinner',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(AddDinnerScreen.routeName);
                  },
                ),
            ],
          ),
        ),
        Container(
            height: recipes.length > 0 ? 300.0 : 150,
            child: recipes.length > 0
                ? ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recipes.length,
                    itemBuilder: (BuildContext context, int index) =>
                        GestureDetector(
                          onTap: () async {
                            await Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => widget.type == 'din'
                                    ? DinnerDetailScreen(recipes[index].id)
                                    : RecipeDetailScreen(recipes[index].id)));
                            setState(() {});
                          },
                          child: Container(
                            margin: EdgeInsets.all(10),
                            width: 230.0,
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Positioned(
                                  bottom: 50.0,
                                  child: Container(
                                    height: 130.0,
                                    width: 200.0,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black45,
                                              offset: Offset(0.0, 2.0),
                                              blurRadius: 6.0)
                                        ]),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            recipes[index].title.length < 15
                                                ? MainAxisAlignment.center
                                                : MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                recipes[index].title.length < 15
                                                    ? const EdgeInsets.only(
                                                        top: 35.0)
                                                    : const EdgeInsets.all(0.0),
                                            child: Text(
                                              recipes[index].title.length < 36
                                                  ? recipes[index].title
                                                  : recipes[index]
                                                      .title
                                                      .substring(0, 36),
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 1.2,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20.0),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black45,
                                            offset: Offset(0.0, 2.0),
                                            blurRadius: 6.0)
                                      ]),
                                  child: Stack(
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child: Image(
                                          height: 150.0,
                                          width: 150.0,
                                          image: NetworkImage(
                                              recipes[index].imageUrl),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (widget.type == 'per' ||
                                    widget.type == 'din')
                                  Positioned(
                                      top: 0.0,
                                      right: 0.0,
                                      child: ClipOval(
                                        child: Material(
                                          color: Colors.red, // button color
                                          child: InkWell(
                                            splashColor:
                                                Colors.green, // inkwell color
                                            child: SizedBox(
                                                width: 56,
                                                height: 56,
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                )),
                                            onTap: () {
                                              _showdeletedialog(
                                                  recipes[index].id);
                                            },
                                          ),
                                        ),
                                      )),
                                if (widget.type == 'per' ||
                                    widget.type == 'din')
                                  Positioned(
                                      top: 0.0,
                                      left: 0.0,
                                      child: ClipOval(
                                        child: Material(
                                          color: Colors.blue, // button color
                                          child: InkWell(
                                            splashColor:
                                                Colors.green, // inkwell color
                                            child: SizedBox(
                                                width: 56,
                                                height: 56,
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Colors.white,
                                                )),
                                            onTap: () {
                                              widget.type == 'per'
                                                  ? Navigator.of(context)
                                                      .pushNamed(
                                                          EditRecipeScreen
                                                              .routeName,
                                                          arguments:
                                                              recipes[index].id)
                                                  : Navigator.of(context)
                                                      .pushNamed(
                                                          EditDinnerScreen
                                                              .routeName,
                                                          arguments:
                                                              recipes[index]
                                                                  .id);
                                            },
                                          ),
                                        ),
                                      )),
                              ],
                            ),
                          ),
                        ))
                : Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        widget.type == 'fav' ? Icons.favorite : Icons.add,
                        size: 50,
                      ),
                      if (widget.type == 'per' || widget.type == 'din')
                        Text(
                          'Please start adding something clicking the button above',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      if (widget.type == 'fav')
                        Text(
                          'Mark some recipes as favourite with the specific button',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                    ],
                  )))
      ],
    );
  }
}
