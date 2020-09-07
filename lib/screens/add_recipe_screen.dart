import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/services/recipe.dart';
import 'package:flutter_complete_guide/services/recipes.dart';
import 'package:flutter_complete_guide/widgets/add_recipe.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddRecipeScreen extends StatefulWidget {
  static const routeName = '/newrecipe';

  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  var _isLoading = false;
  var _isDone = false;

  var uuid = Uuid();

  void _submitAuthForm(
    String title,
    String description,
    String type,
    int duration,
    String complexity,
    String affordability,
    String creatorId,
    List<String> ingredients,
    List<String> steps,
    File image,
    BuildContext ctx,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      var id = uuid.v1();
      final ref =
          FirebaseStorage.instance.ref().child('recipe_img').child(id + 'jpg');

      await ref.putFile(image).onComplete;

      final url = await ref.getDownloadURL();

      Recipe newRecipe = new Recipe(
        title: title,
        creatorId: creatorId,
        description: description,
        imageUrl: url,
        ingredients: ingredients,
        steps: steps,
        duration: duration,
        type: type,
        complexity: complexity,
        affordability: affordability,
      );

      await Provider.of<Recipes>(context).addRecipe(newRecipe).then((value) {
        setState(() {
          _isLoading = false;
          _isDone = true;
        });
      });
    } on PlatformException catch (err) {
      var message = 'An error occurred';

      if (err.message != null) {
        message = err.message;
      }

      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void _showErrorDialog() {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Do you need help?'),
          content: Text(
              'To add a new Recipe fill all the text field in this page and check evrything you find.\n\nBECAREFUL: for the ingridients and the steps, divdide each element from the next one with a new line'),
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

    return Scaffold(
        appBar: AppBar(
          title: Text('Add Recipe'),
          actions: <Widget>[
            FlatButton.icon(
                onPressed: _showErrorDialog,
                icon: Icon(Icons.help),
                label: Text('Help'))
          ],
        ),
        body: AddRecipe(
          _submitAuthForm,
          _isLoading,
          _isDone,
        ));
  }
}
