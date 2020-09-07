import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/services/dinner.dart';
import 'package:flutter_complete_guide/services/dinners.dart';
import 'package:flutter_complete_guide/widgets/add_dinner.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddDinnerScreen extends StatefulWidget {
  static const routeName = '/newdinner';

  @override
  _AddDinnerScreenState createState() => _AddDinnerScreenState();
}

class _AddDinnerScreenState extends State<AddDinnerScreen> {
  var _isLoading = false;
  var _isDone = false;

  var uuid = Uuid();

  Future<bool> _submitForm(
    final String creatorId,
    final String title,
    final String description,
    final double price,
    final int maxNum,
    final Timestamp date,
    List<dynamic> participants,
    final String address,
    final String lat,
    final String lon,
    List<dynamic> dishes,
    File image,
    BuildContext ctx,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      var id = uuid.v1();
      final ref =
          FirebaseStorage.instance.ref().child('dinner_img').child(id + 'jpg');

      await ref.putFile(image).onComplete;

      final url = await ref.getDownloadURL();

      Dinner newDinner = new Dinner(
          title: title,
          creatorId: creatorId,
          description: description,
          imageUrl: url,
          maxNum: maxNum,
          address: address,
          dishes: dishes,
          price: price,
          date: date,
          lat: lat,
          lon: lon,
          participants: participants);

      await Provider.of<Dinners>(context).addDinner(newDinner).then((value) {
        setState(() {
          _isLoading = false;
          _isDone = true;
        });
        return true;
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
              'To add a new Dinner fill all the text field in this page and check evrything you find.\n\nBECAREFUL: for the menu, divdide each element from the next one with a new line '),
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
          title: Text('Add Dinner'),
          actions: <Widget>[
            FlatButton.icon(
                onPressed: _showErrorDialog,
                icon: Icon(Icons.help),
                label: Text('Help'))
          ],
        ),
        body: AddDinner(_submitForm, _isLoading, _isDone));
  }
}
