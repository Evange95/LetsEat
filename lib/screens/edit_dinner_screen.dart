import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/services/dinner.dart';
import 'package:flutter_complete_guide/services/dinners.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EditDinnerScreen extends StatefulWidget {
  static const routeName = '/edit-Dinner';

  @override
  _EditDinnerScreenState createState() => _EditDinnerScreenState();
}

class _EditDinnerScreenState extends State<EditDinnerScreen> {
  final _form = GlobalKey<FormState>();
  var _editedDinner = Dinner(
      id: null,
      title: '',
      description: '',
      imageUrl: '',
      price: 0,
      maxNum: 0,
      date: null,
      dishes: []);
  Map _initValues = {
    'title': '',
    'description': '',
    'imageUrl': '',
    'price': 0,
    'maxNum': '',
    'date': '',
    'dishes': [],
  };
  var _isInit = true;
  var _isLoading = false;
  var _isDone = false;

  @override
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final dinnerId = ModalRoute.of(context).settings.arguments as String;
      if (dinnerId != null) {
        _editedDinner = Provider.of<Dinners>(context, listen: false)
            .findDinnerById(dinnerId);
        _initValues = {
          'title': _editedDinner.title,
          'description': _editedDinner.description,
          'imageUrl': _editedDinner.imageUrl,
          'price': _editedDinner.price,
          'maxNum': _editedDinner.maxNum,
          'date': _editedDinner.date,
          'dishes': _editedDinner.dishes
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
    if (_editedDinner.id != null) {
      await Provider.of<Dinners>(context, listen: false)
          .updateDinner(_editedDinner.id, _editedDinner.toJson());
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
          title: Text('Edit Dinner'),
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
                          backgroundImage: NetworkImage(_editedDinner.imageUrl),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: _initValues['title'],
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
                            _editedDinner.title = value;
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
                            _editedDinner.description = value;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          initialValue: _initValues['price'].toString(),
                          keyboardType: TextInputType.number,
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
                            _editedDinner.price = double.parse(value);
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          initialValue: _initValues['maxNum'].toString(),
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
                            hintText:
                                'Insert the number of people for this dinner',
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                          ),
                          onSaved: (value) {
                            _editedDinner.maxNum = int.parse(value);
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          initialValue: _initValues['dishes'].join('\n'),
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
                          maxLines: 15,
                          onSaved: (value) {
                            _editedDinner.dishes = value.split('\n');
                          },
                        ),
                        Divider(color: Colors.black),
                        Padding(
                          padding: const EdgeInsets.only(left: 38.0, top: 10),
                          child: ListTile(
                            leading: Icon(Icons.calendar_today),
                            title: Text(
                              _editedDinner.date != null
                                  ? DateFormat('dd-MM-yyyy').format(
                                      DateTime.parse(_editedDinner.date
                                          .toDate()
                                          .toString()))
                                  : 'dd-MM-yyyy',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14),
                            ),
                            subtitle: Text(
                              _editedDinner.date != null
                                  ? DateFormat('kk:mm').format(DateTime.parse(
                                      _editedDinner.date.toDate().toString()))
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
                                    _editedDinner.date =
                                        Timestamp.fromDate(date);
                                  }, onConfirm: (date) {
                                    _editedDinner.date =
                                        Timestamp.fromDate(date);
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
                                'Edit Dinner',
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
