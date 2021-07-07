import 'package:flutter/material.dart';
import 'package:sy_rezosocial/controller/detail_post_controller.dart';
import 'package:sy_rezosocial/models/post.dart';
import 'package:sy_rezosocial/models/monuser.dart';
import 'package:sy_rezosocial/util/date_helper.dart';
import 'package:sy_rezosocial/util/fire_helper.dart';
import 'package:sy_rezosocial/view/my_material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PostTile extends StatelessWidget {
  final Post post;
  final MonUser user;
  final bool detail;

  PostTile({@required this.post, @required this.user, this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.0),
      child: Card(
        elevation: 5.0,
        child: PaddingWith(
            top: 10.0,
            left: 10.0,
            right: 10.0,
            bottom: 10.0,
            widget: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ProfilImage(urlString: user.imageUrl, onPressed: null),
                    Column(
                      children: <Widget>[
                        MyText(
                          "${user.surname} ${user.name}",
                          color: baseAccent,
                        ),
                        MyText(
                          DateHelper().myDate(post.date).toString(),
                          // "${post.date}",
                          color: pointer,
                        ),
                      ],
                    )
                  ],
                ),
                (post.imageUrl != "" && post.imageUrl != null)
                    ? PaddingWith(
                        widget: Container(
                        height: 1.0,
                        width: MediaQuery.of(context).size.width,
                        color: baseAccent,
                      ))
                    : Container(
                        height: 0.0,
                      ),
                (post.imageUrl != "" && post.imageUrl != null)
                    ? PaddingWith(
                        widget: Container(
                        height: MediaQuery.of(context).size.width * 0.85,
                        width: MediaQuery.of(context).size.width * 0.85,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            image: DecorationImage(
                                image:
                                    CachedNetworkImageProvider(post.imageUrl),
                                fit: BoxFit.cover)),
                      ))
                    : Container(
                        height: 0.0,
                      ),
                (post.text != "" && post.text != null)
                    ? PaddingWith(
                        widget: Container(
                        height: 1.0,
                        width: MediaQuery.of(context).size.width,
                        color: baseAccent,
                      ))
                    : Container(
                        height: 0.0,
                      ),
                (post.text != "" && post.text != null)
                    ? PaddingWith(
                        widget: MyText(
                        post.text,
                        color: baseAccent,
                      ))
                    : Container(
                        height: 0.0,
                      ),
                PaddingWith(
                    widget: Container(
                  height: 1.0,
                  width: MediaQuery.of(context).size.width,
                  color: baseAccent,
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon:
                          (post.likes.contains(me.uid) ? likeFull : likeEmpty),
                      onPressed: () => FireHelper().addLike(post),
                    ),
                    MyText(
                      post.likes.length.toString(),
                      color: baseAccent,
                    ),
                    IconButton(
                      icon: msgIcon,
                      onPressed: () {
                        if (!detail) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (BuildContext ctx) {
                            return DetailPost(post: post, user: user);
                          }));
                        }
                      },
                    ),
                    MyText(
                      post.comments.length.toString(),
                      color: baseAccent,
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
