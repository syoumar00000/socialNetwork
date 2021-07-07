import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sy_rezosocial/models/monuser.dart';
import 'package:sy_rezosocial/util/fire_helper.dart';
import 'package:sy_rezosocial/util/user_tile.dart';
import 'package:sy_rezosocial/view/my_material.dart';

class UsersPage extends StatefulWidget {
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FireHelper().fireUser.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> document = snapshot.data.docs;
            return NestedScrollView(
              headerSliverBuilder: (BuildContext build, bool scrolled) {
                return [
                  MyAppBar(title: "Liste des utilisateurs", image: eventImage),
                ];
              },
              body: ListView.builder(
                itemCount: document.length,
                itemBuilder: (BuildContext ctx, int index) {
                  MonUser user = MonUser(document[index]);
                  return UserTile(
                    user: user,
                  );
                },
              ),
            );
          } else {
            return LoadingCenter();
          }
        });
  }
}
