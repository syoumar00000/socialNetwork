import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sy_rezosocial/models/notifications.dart';
import 'package:sy_rezosocial/util/fire_helper.dart';
import 'package:sy_rezosocial/view/my_material.dart';
import 'package:sy_rezosocial/view/tiles/notif_tile.dart';

class NotifPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FireHelper()
          .fireNotif
          .doc(me.uid)
          .collection("SingleNotif")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snaps) {
        if (!snaps.hasData) {
          return Center(
            child: MyText(
              "Aucune Notifications...",
              color: pointer,
              fontSize: 40.0,
            ),
          );
        } else {
          // on cree les notifications
          List<DocumentSnapshot> documents = snaps.data.docs;
          return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (BuildContext ctx, int index) {
                MyNotification notif = MyNotification(documents[index]);
                return NotifTile(
                  myNotif: notif,
                );
              });
        }
      },
    );
  }
}
