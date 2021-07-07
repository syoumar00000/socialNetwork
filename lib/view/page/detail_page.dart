import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sy_rezosocial/models/comment.dart';
import 'package:sy_rezosocial/view/my_material.dart';
import 'package:sy_rezosocial/models/monuser.dart';
import 'package:sy_rezosocial/models/post.dart';
import 'package:sy_rezosocial/view/tiles/postTiles.dart';
import 'package:sy_rezosocial/view/tiles/comment_tile.dart';

class DetailPage extends StatelessWidget {
  final MonUser user;
  final Post post;
  DetailPage({this.user, this.post});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: post.ref.snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          Post newPost = Post(snapshot.data);
          return ListView.builder(
            itemCount: newPost.comments.length + 1,
            itemBuilder: (BuildContext ctx, int index) {
              if (index == 0) {
                return PostTile(
                  user: user,
                  post: newPost,
                  detail: true,
                );
              } else {
                Comment comment = Comment(newPost.comments[index - 1]);
                return CommentTile(comment: comment);
              }
            },
          );
        } else {
          return LoadingCenter();
        }
      },
    );
  }
}
