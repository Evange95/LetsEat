import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/services/recipe.dart';
import 'package:flutter_complete_guide/widgets/comments.dart';
import 'package:flutter_complete_guide/widgets/new_comment.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  static const routeName = '/comments';

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  Widget build(BuildContext context) {
    final Recipe recipe = ModalRoute.of(context).settings.arguments;
    final id = Provider.of<FirebaseUser>(context).uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ChangeNotifierProvider.value(
                value: recipe,
                child: Comments(),
              ),
            ),
            if (recipe.isdone)
              ChangeNotifierProvider.value(
                value: recipe,
                child: NewComment(),
              ),
            if (!recipe.isdone)
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: recipe.creatorId == id
                    ? Text('You can only read the comments')
                    : Text('Please do the Recipe to comment'),
              ))
          ],
        ),
      ),
    );
  }
}
