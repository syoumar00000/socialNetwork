import 'package:flutter/material.dart';
import 'package:sy_rezosocial/util/fire_helper.dart';
import 'package:sy_rezosocial/view/my_material.dart';
import 'package:sy_rezosocial/models/monuser.dart';
import 'package:sy_rezosocial/models/post.dart';
import 'package:sy_rezosocial/view/page/detail_page.dart';

class DetailPost extends StatelessWidget {
  MonUser user;
  Post post;
  DetailPost({this.user, this.post});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Scaffold(
      backgroundColor: base,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () {
                  //faire rentrer le clavier lors du clique
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: DetailPage(post: post, user: user),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 1.0,
              color: baseAccent,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 75.0,
              color: base,
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width - 100.0,
                    child: MyTextField(
                      controller: controller,
                      hint: "Laisser un commentaire ...",
                    ),
                  ),
                  IconButton(
                    icon: sendIcon,
                    onPressed: () {
                      //faire rentrer le clavier lors du clique
                      FocusScope.of(context).requestFocus(FocusNode());

                      if (controller.text != null && controller.text != "") {
                        //send to firebase
                        FireHelper()
                            .addComment(post.ref, controller.text, post.userId);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
