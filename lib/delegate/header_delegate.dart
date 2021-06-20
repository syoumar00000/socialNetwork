import 'package:flutter/material.dart';
import 'package:sy_rezosocial/models/monuser.dart';
import 'package:sy_rezosocial/util/alert_helper.dart';
import 'package:sy_rezosocial/view/my_material.dart';

class MyHeader extends SliverPersistentHeaderDelegate {
  MonUser user;
  VoidCallback callback;
  bool scrolled;
  MyHeader(
      {@required this.user, @required this.callback, @required this.scrolled});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.0),
      padding: EdgeInsets.all(10.0),
      color: baseAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          (scrolled)
              ? Container(height: 0.0, width: 0.0)
              : elementDescription("${user.surname} ${user.name}"),
          //MyText("${user.surname} ${user.name}"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ProfilImage(urlString: user.imageUrl, onPressed: null),
              elementDescription((user.description == null)
                  ? "aucune description..."
                  : user.description)
            ],
          ),
          Container(
            height: 1.0,
            width: MediaQuery.of(context).size.width,
            color: base,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              elementDescription("followers : ${user.followers.length}"),
              elementDescription("following : ${user.following.length - 1}"),
              /*  InkWell(
                child: MyText("followers : ${user.followers.length}"),
              ),
              InkWell(
                child: MyText("following : ${user.following.length - 1}"),
              ), */
            ],
          ),
        ],
      ),
    );
  }

  Widget elementDescription(String text) {
    if (user.uid == me.uid) {
      return InkWell(
        child: MyText(text),
        onTap: callback,
      );
    } else {
      return MyText(text);
    }
  }

  @override
  double get maxExtent => (scrolled) ? 150.0 : 200.0;

  @override
  double get minExtent => (scrolled) ? 150.0 : 200.0;

  @override
  bool shouldRebuild(MyHeader oldDelegate) =>
      scrolled != oldDelegate.scrolled || user != oldDelegate.user;
}
