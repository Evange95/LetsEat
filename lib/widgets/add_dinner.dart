import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/services/user.dart';
import 'package:flutter_complete_guide/widgets/pickers/user_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class AddDinner extends StatefulWidget {
  final bool isLoading;
  final bool isDone;

  final void Function(
    String creatorId,
    String title,
    String description,
    double price,
    int maxNum,
    Timestamp date,
    List<dynamic> participants,
    String address,
    String lat,
    String lon,
    List<dynamic> dishes,
    File image,
    BuildContext ctx,
  ) submitFn;

  AddDinner(this.submitFn, this.isLoading, this.isDone);

  @override
  _AddDinnerState createState() => _AddDinnerState();
}

class _AddDinnerState extends State<AddDinner> with Diagnosticable {
  final _formKey = GlobalKey<FormState>();
  var _creatorId = '';
  var _title = '';
  var _description = '';
  var _price = 0.0;
  var _maxNum = 0;
  var _date = null;
  var _participants = [];
  var _address = '';
  var _lat = '';
  var _lon = '';
  var _dishes = [];
  File _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  Future<bool> _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an image.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        _creatorId,
        _title.trim(),
        _description.trim(),
        _price,
        _maxNum,
        _date,
        _participants,
        _address,
        _lat,
        _lon,
        _dishes,
        _userImageFile,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    _creatorId = user.uid;
    _lat = user.lat;
    _lon = user.lon;
    _address = user.address;
    return SafeArea(
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
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    UserImagePicker(_pickedImage),
                    TextFormField(
                      key: ValueKey('title'),
                      validator: (value) {
                        if (value.isEmpty || value.length > 18) {
                          return 'Please enter a title shorter than 18 character';
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
                    TextFormField(
                      keyboardType: TextInputType.numberWithOptions(),
                      key: ValueKey('price'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please insert a number';
                        }
                        return null;
                      },
                      decoration: new InputDecoration(
                        labelText: 'Price',
                        hintText: 'Insert a price',
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                      onSaved: (value) {
                        _price = double.parse(value);
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      key: ValueKey('maxnum'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter the maximum number of people for the dinner';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.numberWithOptions(),
                      decoration: new InputDecoration(
                        labelText: 'Maximum number of people',
                        hintText: 'Insert the number of people for this dinner',
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                      onSaved: (value) {
                        _maxNum = int.parse(value);
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      key: ValueKey('dishes'),
                      validator: (value) {
                        if (value.isEmpty || value.split('\n').length < 2) {
                          return 'Please enter at least 2 ingredients';
                        }
                        return null;
                      },
                      decoration: new InputDecoration(
                        labelText: 'Dishes',
                        hintText:
                            'Please divide each dish to the others with a new line',
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                      maxLines: 10,
                      onSaved: (value) {
                        _dishes = value.split('\n');
                      },
                    ),
                    Divider(color: Colors.black),
                    Padding(
                      padding: const EdgeInsets.only(left: 38.0, top: 10),
                      child: ListTile(
                        leading: Icon(Icons.calendar_today),
                        title: Text(
                          _date != null
                              ? DateFormat('dd-MM-yyyy').format(
                                  DateTime.parse(_date.toDate().toString()))
                              : 'dd-MM-yyyy',
                          textAlign: TextAlign.center,
                        ),
                        subtitle: Text(
                          _date != null
                              ? DateFormat('kk:mm').format(
                                  DateTime.parse(_date.toDate().toString()))
                              : 'hh:mm',
                          textAlign: TextAlign.center,
                        ),
                        trailing: FlatButton(
                            onPressed: () {
                              DatePicker.showDateTimePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime(2018, 3, 5),
                                  maxTime: DateTime(2040, 6, 7),
                                  onChanged: (date) {
                                _date = Timestamp.fromDate(date);
                              }, onConfirm: (date) {
                                _date = Timestamp.fromDate(date);
                                setState(() {});
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.it);
                            },
                            child: Icon(Icons.arrow_downward)),
                      ),
                    ),
                    Divider(color: Colors.black),
                    SizedBox(height: 40),
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
                            'Add Dinner',
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
    ));
  }
}
