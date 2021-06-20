import 'package:flutter/material.dart';
import 'package:sy_rezosocial/models/monuser.dart';
import 'package:sy_rezosocial/view/my_material.dart';
import 'package:sy_rezosocial/view/page/profil_page.dart';

class UserTile extends StatelessWidget {
  final MonUser user;
  UserTile({this.user});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext ctx) {
          return Scaffold(
            backgroundColor: base,
            body: SafeArea(
              child: ProfilPage(user),
            ),
          );
        }));
      },
      child: Container(
        color: Colors.transparent,
        margin: EdgeInsets.all(2.5),
        child: Card(
          color: white,
          elevation: 5.0,
          child: Container(
            padding: EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    ProfilImage(urlString: user.imageUrl, onPressed: null),
                    MyText(
                      "${user.surname}  ${user.name}",
                      color: baseAccent,
                    ),
                  ],
                ),
                (user.uid == me.uid)
                    ? Container(
                        width: 0.0,
                      )
                    : FollowButton(user: user),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
