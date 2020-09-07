import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/services/recipe.dart';
import 'package:flutter_complete_guide/services/recipes.dart';
import 'package:provider/provider.dart';

class EditRecipeScreen extends StatefulWidget {
  static const routeName = '/edit-Recipe';

  @override
  _EditRecipeScreenState createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  final _form = GlobalKey<FormState>();

  var types = ['Apertizer', 'First', 'Main', 'Side', 'Dessert'];
  var _editedRecipe = Recipe(
    id: null,
    title: '',
    description: '',
    imageUrl: '',
    duration: 0,
    type: '',
    complexity: '',
    affordability: '',
    creatorId: '',
    ingredients: [],
    steps: [],
  );
  Map _initValues = {
    'title': '',
    'description': '',
    'imageUrl': '',
    'duration': 0,
    'type': '',
    'complexity': '',
    'affordability': '',
    'ingredients': [],
    'steps': []
  };
  var _isInit = true;
  var _isLoading = false;
  var _isDone = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final dinnerId = ModalRoute.of(context).settings.arguments as String;
      if (dinnerId != null) {
        _editedRecipe = Provider.of<Recipes>(context, listen: false)
            .findRecipeById(dinnerId);
        _initValues = {
          'title': _editedRecipe.title,
          'description': _editedRecipe.description,
          'imageUrl': _editedRecipe.imageUrl,
          'duration': _editedRecipe.duration,
          'complexity': _editedRecipe.complexity,
          'affordability': _editedRecipe.affordability,
          'ingredients': _editedRecipe.ingredients,
          'steps': _editedRecipe.steps
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedRecipe.id != null) {
      await Provider.of<Recipes>(context, listen: false)
          .updateRecipe(_editedRecipe.id, _editedRecipe.toJson());
    }
    setState(() {
      _isLoading = false;
      _isDone = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Recipe'),
        ),
        body: SafeArea(
            child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Card(
                elevation: 50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: _form,
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(_editedRecipe.imageUrl),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: _initValues['title'],
                          key: ValueKey('title'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a title.';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          decoration: new InputDecoration(
                            labelText: "Title",
                            hintText: 'Insert a Title',
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                          ),
                          onSaved: (value) {
                            _editedRecipe.title = value;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          initialValue: _initValues['description'],
                          key: ValueKey('description'),
                          validator: (value) {
                            if (value.isEmpty || value.split(' ').length < 4) {
                              return 'Please enter at least 4 words';
                            }
                            return null;
                          },
                          decoration: new InputDecoration(
                            labelText: 'Description',
                            hintText: 'Insert a description',
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                          ),
                          maxLines: 3,
                          onSaved: (value) {
                            _editedRecipe.description = value;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          decoration: new BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(25.0),
                                topRight: const Radius.circular(25.0),
                                bottomLeft: const Radius.circular(25.0),
                                bottomRight: const Radius.circular(25.0),
                              )),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: DropdownButton<String>(
                              value: _editedRecipe.type,
                              isExpanded: true,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: Colors.black),
                              underline: Container(
                                height: 1,
                                color: Colors.black,
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  _editedRecipe.type = newValue;
                                });
                              },
                              items: types.map((String type) {
                                return DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          initialValue: _initValues['duration'].toString(),
                          key: ValueKey('duration'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a number';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.numberWithOptions(),
                          decoration: new InputDecoration(
                            labelText: 'Duration',
                            hintText:
                                'Insert a how long this recipe will take in minutes',
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                          ),
                          onSaved: (value) {
                            _editedRecipe.duration = int.parse(value);
                          },
                        ),
                        Divider(color: Colors.black),
                        Padding(
                          padding: const EdgeInsets.only(right: 220.0, top: 10),
                          child: Text('Complexity',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 18)),
                        ),
                        ListTile(
                          title: const Text('Simple'),
                          leading: Radio(
                            value: 'Simple',
                            groupValue: _editedRecipe.complexity,
                            onChanged: (String value) {
                              setState(() {
                                _editedRecipe.complexity = value;
                              });
                              return true;
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('Challenging'),
                          leading: Radio(
                            value: 'Challenging',
                            groupValue: _editedRecipe.complexity,
                            onChanged: (String value) {
                              setState(() {
                                _editedRecipe.complexity = value;
                              });
                              return true;
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('Hard'),
                          leading: Radio(
                            value: 'Hard',
                            groupValue: _editedRecipe.complexity,
                            onChanged: (String value) {
                              setState(() {
                                _editedRecipe.complexity = value;
                              });
                              return true;
                            },
                          ),
                        ),
                        Divider(color: Colors.black),
                        Padding(
                          padding: const EdgeInsets.only(right: 200.0, top: 10),
                          child: Text('Affordability',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 18)),
                        ),
                        ListTile(
                          title: const Text('Affordable'),
                          leading: Radio(
                            value: 'Affordable',
                            groupValue: _editedRecipe.affordability,
                            onChanged: (String value) {
                              setState(() {
                                _editedRecipe.affordability = value;
                              });
                              return true;
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('Pricey'),
                          leading: Radio(
                            value: 'Pricey',
                            groupValue: _editedRecipe.affordability,
                            onChanged: (String value) {
                              setState(() {
                                _editedRecipe.affordability = value;
                              });
                              return true;
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('Luxurious'),
                          leading: Radio(
                            value: 'Luxurious',
                            groupValue: _editedRecipe.affordability,
                            onChanged: (String value) {
                              setState(() {
                                _editedRecipe.affordability = value;
                              });
                              return true;
                            },
                          ),
                        ),
                        Divider(color: Colors.black),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          initialValue: _initValues['ingredients'].join('\n'),
                          key: ValueKey('ingredients'),
                          validator: (value) {
                            if (value.isEmpty || value.split('\n').length < 2) {
                              return 'Please enter at least 2 ingredients';
                            }
                            return null;
                          },
                          decoration: new InputDecoration(
                            labelText: 'Ingredients',
                            hintText:
                                'Please divide each ingredient to the others with a new line',
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                          ),
                          maxLines: 15,
                          onSaved: (value) {
                            _editedRecipe.ingredients = value.split('\n');
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          initialValue: _initValues['steps'].join('\n'),
                          key: ValueKey('steps'),
                          validator: (value) {
                            if (!value.contains('\n') ||
                                value.isEmpty ||
                                value.split('\n').length < 2) {
                              return 'Please enter at least 2 ingredients';
                            }
                            return null;
                          },
                          decoration: new InputDecoration(
                            labelText: 'Steps',
                            hintText:
                                'Please divide each steps to the others with a new line ',
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                          ),
                          maxLines: 10,
                          onSaved: (value) {
                            _editedRecipe.steps = value.split('\n');
                          },
                        ),
                        SizedBox(height: 12),
                        if (_isLoading && !_isDone) CircularProgressIndicator(),
                        if (_isDone)
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                            color: Colors.greenAccent,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.done,
                                  ),
                                  Text(
                                    'Done',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        if (!_isLoading && !_isDone)
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                            color: Colors.greenAccent,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                'Edit Recipe',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            onPressed: () {
                              _saveForm();
                            },
                          ),
                        SizedBox(
                          height: 30,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        )));
  }
}
