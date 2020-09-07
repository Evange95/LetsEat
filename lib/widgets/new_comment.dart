import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_complete_guide/services/recipe.dart';
import 'package:flutter_complete_guide/services/user.dart';
import 'package:provider/provider.dart';

class NewComment extends StatefulWidget {

  @override
  _NewCommentState createState() => _NewCommentState();
}

class _NewCommentState extends State<NewComment> {
  final _controller = new TextEditingController();
  var _enteredMessage = '';

  void _sendMessage(Recipe recipe,User user) async {
    FocusScope.of(context).unfocus();
    var comm = {
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'name': user.name
    };

    recipe.addComment(comm);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    var recipe = Provider.of<Recipe>(context);
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Send a message...'),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
              color: Theme.of(context).primaryColor,
              icon: Icon(
                Icons.send,
              ),
              onPressed: () {
                _sendMessage(recipe,user);
              })
        ],
      ),
    );
  }
}
