import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sy_rezosocial/controller/detail_post_controller.dart';
import 'package:sy_rezosocial/models/monuser.dart';
import 'package:sy_rezosocial/models/notifications.dart';
import 'package:sy_rezosocial/models/post.dart';
import 'package:sy_rezosocial/util/fire_helper.dart';
import 'package:sy_rezosocial/view/my_material.dart';
import 'package:sy_rezosocial/view/page/profil_page.dart';

class NotifTile extends StatelessWidget {
  final MyNotification myNotif;

  NotifTile({this.myNotif});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FireHelper().fire_user.doc(myNotif.userId).snapshots(),
        builder: (BuildContext ctx, AsyncSnapshot<DocumentSnapshot> snap) {
          if (!snap.hasData) {
            return Container();
          } else {
            MonUser user = MonUser(snap.data);
            return InkWell(
              onTap: () {
                myNotif.notifRef.update({keySeen: true});
                if (myNotif.type == keyFollowers) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext build) {
                    return Scaffold(
                      body: SafeArea(child: ProfilPage(user)),
                    );
                  }));
                } else {
                  myNotif.ref.get().then((snap) {
                    Post post = Post(snap);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext ctx) {
                      return DetailPost(
                        post: post,
                        user: user,
                      );
                    }));
                  });
                }
              },
              child: Container(
                color: Colors.transparent,
                margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
                child: Card(
                  elevation: 5.0,
                  color: (!myNotif.seen) ? white : base,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            ProfilImage(
                                urlString: user.imageUrl, onPressed: null),
                            MyText(
                              myNotif.date,
                              color: pointer,
                            ),
                          ],
                        ),
                        MyText(
                          myNotif.text,
                          color: baseAccent,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }
}
