import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/pickers/user_image_picker.dart';
import 'package:provider/provider.dart';

class AddRecipe extends StatefulWidget {
  AddRecipe(
    this.submitFn,
    this.isLoading,
    this.isDone,
  );

  final bool isLoading;
  final bool isDone;
  final void Function(
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
  ) submitFn;

  @override
  _AddRecipeState createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  final _formKey = GlobalKey<FormState>();
  var _title = '';
  var _description = '';
  var _type = 'Apertizer';
  var _duration = 0;
  var _complexity = '';
  var _affordability = 'Affordable';
  var _creatorId = '';
  var _ingredients = [];
  var _steps = [];
  File _userImageFile;

  var types = ['Apertizer', 'First', 'Main', 'Side', 'Dessert'];

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate() &&
        _type != '' &&
        _complexity != '' &&
        _affordability != '';
    FocusScope.of(context).unfocus();

    if (_userImageFile == null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an image.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        _title.trim(),
        _description.trim(),
        _type.trim(),
        _duration,
        _complexity.trim(),
        _affordability.trim(),
        _creatorId,
        _ingredients,
        _steps,
        _userImageFile,
        context,
      );
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
            'Please fill the missing fields $_type,$_affordability, $_complexity'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    _creatorId = Provider.of<FirebaseUser>(context).uid;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SafeArea(
          child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Card(
              elevation: 50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      UserImagePicker(_pickedImage),
                      TextFormField(
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
                          _title = value;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
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
                          _description = value;
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
                            value: _type != '' ? _type : types[0],
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
                                _type = newValue;
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
                          _duration = int.parse(value);
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
                          groupValue: _complexity,
                          onChanged: (String value) {
                            setState(() {
                              _complexity = value;
                            });
                            return true;
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Challenging'),
                        leading: Radio(
                          value: 'Challenging',
                          groupValue: _complexity,
                          onChanged: (String value) {
                            setState(() {
                              _complexity = value;
                            });
                            return true;
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Hard'),
                        leading: Radio(
                          value: 'Hard',
                          groupValue: _complexity,
                          onChanged: (String value) {
                            setState(() {
                              _complexity = value;
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
                          groupValue: _affordability,
                          onChanged: (String value) {
                            setState(() {
                              _affordability = value;
                            });
                            return true;
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Pricey'),
                        leading: Radio(
                          value: 'Pricey',
                          groupValue: _affordability,
                          onChanged: (String value) {
                            setState(() {
                              _affordability = value;
                            });
                            return true;
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Luxurious'),
                        leading: Radio(
                          value: 'Luxurious',
                          groupValue: _affordability,
                          onChanged: (String value) {
                            setState(() {
                              _affordability = value;
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
                          _ingredients = value.split('\n');
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
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
                          _steps = value.split('\n');
                        },
                      ),
                      SizedBox(height: 12),
                      if (widget.isLoading && !widget.isDone)
                        CircularProgressIndicator(),
                      if (widget.isDone)
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
                      if (!widget.isLoading && !widget.isDone)
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          color: Colors.greenAccent,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              'Add Recipe',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          onPressed: () {
                            _trySubmit();
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
      )),
    );
  }
}
