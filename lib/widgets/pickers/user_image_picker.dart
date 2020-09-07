import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn);

  final void Function(File pickedImage) imagePickFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;

  void _pickImage(n) async {
    final pickedImageFile = await ImagePicker.pickImage(
      source: n ? ImageSource.camera : ImageSource.gallery,
    );
    setState(() {
      _pickedImage = pickedImageFile;
    });
    widget.imagePickFn(pickedImageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: _pickedImage != null
              ? FileImage(_pickedImage)
              : NetworkImage(
                  'https://www.freeiconspng.com/uploads/upload-icon-31.png'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FlatButton.icon(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              textColor: Theme.of(context).primaryColor,
              onPressed: () {
                _pickImage(true);
              },
              icon: Icon(Icons.camera_alt),
              label: Text('Add Image'),
            ),
            FlatButton.icon(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              textColor: Theme.of(context).primaryColor,
              onPressed: () {
                _pickImage(false);
              },
              icon: Icon(Icons.image),
              label: Text('From Gallery'),
            ),
          ],
        )
      ],
    );
  }
}
