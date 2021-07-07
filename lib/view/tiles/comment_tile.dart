import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sy_rezosocial/models/comment.dart';
import 'package:sy_rezosocial/util/fire_helper.dart';
import 'package:sy_rezosocial/view/my_material.dart';
import 'package:sy_rezosocial/models/monuser.dart';

class CommentTile extends StatelessWidget {
  final Comment comment;
  CommentTile({this.comment});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FireHelper().fireUser.doc(comment.userId).snapshots(),
      builder: (BuildContext ctx, AsyncSnapshot<DocumentSnapshot> snap) {
        if (snap.hasData) {
          MonUser user = MonUser(snap.data);
          return Container(
            color: white,
            margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 2.5),
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        ProfilImage(
                          urlString: user.imageUrl,
                          onPressed: null,
                          size: 15.0,
                        ),
                        MyText(
                          "${user.surname}  ${user.name}",
                          color: base,
                        ),
                      ],
                    ),
                    MyText(
                      comment.date,
                      color: pointer,
                    ),
                  ],
                ),
                MyText(
                  comment.text,
                  color: baseAccent,
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
