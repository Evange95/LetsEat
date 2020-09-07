import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/services/recipes.dart';
import 'package:provider/provider.dart';
import '../screens/recipe_detail_screen.dart';

class RecipeRow extends StatelessWidget {
  final String id;
  RecipeRow(this.id);

  @override
  Widget build(BuildContext context) {
    final meal =
        Provider.of<Recipes>(context, listen: false).findRecipeById(id);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => RecipeDetailScreen(meal.id)));
        },
        child: Container(
          height: 120,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black45,
                    offset: Offset(0.0, 2.0),
                    blurRadius: 6.0)
              ]),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image(
                    height: 90.0,
                    width: 90.0,
                    image: NetworkImage(meal.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 250,
                      child: Text(
                        meal.title.toString(),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(meal.complexity.toString()),
                        SizedBox(
                          width: 20,
                        ),
                        Text(meal.affordability.toString())
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
