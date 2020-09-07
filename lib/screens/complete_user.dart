import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/services/user.dart';
import 'package:flutter_complete_guide/screens/complete_profile_screen.dart';
import 'package:geolocator/geolocator.dart' as geoloc;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CompleteUser extends StatefulWidget {
  @override
  _CompleteUserState createState() => _CompleteUserState();
}

class _CompleteUserState extends State<CompleteUser> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _numberController = TextEditingController();

  Map<String, String> _profileData = {
    'name': '',
    'surname': '',
    'address': '',
    'number': '',
    'city': '',
    'lat': null,
    'lon': null,
  };

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _nameController.dispose();
    _surnameController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
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

  @override
  Widget build(BuildContext context) {
    geoloc.Position _position;

    final _user = Provider.of<User>(context);
    final _uid = Provider.of<FirebaseUser>(context).uid;
    bool _error = false;

    Future<void> _submit() async {
      if (_nameController.text != '' &&
          _surnameController.text != '' &&
          !_error) {
        try {
          _profileData['name'] = _nameController.text.trim();
          _profileData['surname'] = _surnameController.text.trim();
          _profileData['number'] = _numberController.text.trim();
          final result = await _user.setUserData(_uid, _profileData);
          return result;
        } catch (e) {
          print(e);
        }
      } else {
        throw ('Something goes wrong, please check');
      }
    }

    Future<void> _getDataFromAddress() async {
      var street = _numberController.text + ' ' + _addressController.text;
      final url =
          'https://nominatim.openstreetmap.org/search?street=$street&city=${_cityController.text}&format=json&addressdetails=1';
      final response = await http.get(url);
      final data = json.decode(response.body);
      if (response.body == '[]') {
        _showErrorDialog('Please insert a valid address');
        _error = true;
      } else {
        _profileData['city'] = data[0]['address']['city'];
        _profileData['address'] = data[0]['address']['road'];
        _profileData['lat'] = data[0]['lat'];
        _profileData['lon'] = data[0]['lon'];
      }
    }

    Future<void> _getAddressFromCoordinates() async {
      final url =
          'https://nominatim.openstreetmap.org/reverse?lat=${_position.latitude}&lon=${_position.longitude}&format=json';
      final response = await http.get(url);
      final data = json.decode(response.body);
      _cityController.text = data['address']['city'];
      _addressController.text = data['address']['road'] != null
          ? data['address']['road']
          : 'Sorry we can not find your address';
    }

    Future<void> _getlocation() async {
      var curr = await geoloc.Geolocator()
          .getCurrentPosition(desiredAccuracy: geoloc.LocationAccuracy.best);
      setState(() {
        _position = curr;
      });
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(8),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 90),
              child: Text(
                'Just few moments to complete your profile',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Card(
              elevation: 50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: new InputDecoration(
                        labelText: "Enter Name",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _surnameController,
                      decoration: new InputDecoration(
                        labelText: "Enter Surname",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _cityController,
                      decoration: new InputDecoration(
                        labelText: "Enter City",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _addressController,
                      decoration: new InputDecoration(
                        labelText: "Enter Address",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _numberController,
                      decoration: new InputDecoration(
                        labelText: "Enter Civic Number",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                        color: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        child: Text('Get your position automatically'),
                        onPressed: () async {
                          await _getlocation().then((value) async {
                            await _getAddressFromCoordinates()
                                .then((value) async {});
                          });
                        }),
                    RaisedButton(
                      color: Colors.greenAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      child: Text('Continue'),
                      onPressed: () async {
                        await _getDataFromAddress().then((value) async {
                          await _submit();
                          Navigator.of(context).pushReplacementNamed(
                              CompleteProfileScreen.routeName);
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
