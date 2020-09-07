import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/services/recipe.dart';
import 'package:flutter_complete_guide/widgets/comments_bubble.dart';
import 'package:provider/provider.dart';

class Comments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var recid = Provider.of<Recipe>(context).id;

    return StreamBuilder(
        stream: Firestore.instance
            .collection('recipes')
            .document(recid)
            .snapshots(),
        builder: (ctx, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          var comments = chatSnapshot.data['comments'];
          if (comments == null) {
            comments = [];
          }
          return ListView.builder(
            reverse: true,
            itemCount: comments.length,
            itemBuilder: (ctx, index) => comments.length > 0
                ? CommentBubble(
                    comments[index]['text'],
                    comments[index]['name'],
                  )
                : Center(
                    child: Text('No comments yet'),
                  ),
          );
        });

    //  return ListView.builder(
    //             reverse: true,
    //             itemCount: comments.length,
    //             itemBuilder: (ctx, index) => Row(
    //               children:[
    //                 Text(comments[index]['text']),
    //                 // chatDocs[index]['username'],
    //                 // chatDocs[index]['userId'] == futureSnapshot.data.uid,
    //               ]

    //             ),
    //           );
  }
}
