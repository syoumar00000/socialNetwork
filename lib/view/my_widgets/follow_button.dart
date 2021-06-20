import 'package:flutter/material.dart';
import 'package:sy_rezosocial/util/fire_helper.dart';
import 'package:sy_rezosocial/models/monuser.dart';
import 'package:sy_rezosocial/view/my_material.dart';
import 'package:sy_rezosocial/view/my_widgets/my_text.dart';

class FollowButton extends TextButton {
  FollowButton({@required MonUser user})
      : super(
          onPressed: () {
            FireHelper().addFollow(user);
          },
          child: MyText(
            me.following.contains(user.uid) ? "Ne Plus Suivre" : "Suivre",
            color: pointer,
          ),
        );
}
