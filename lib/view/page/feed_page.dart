import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sy_rezosocial/models/monuser.dart';
import 'package:sy_rezosocial/models/post.dart';
import 'package:sy_rezosocial/util/fire_helper.dart';
import 'package:sy_rezosocial/view/my_material.dart';
import 'package:sy_rezosocial/view/tiles/postTiles.dart';

class FeedPage extends StatefulWidget {
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<FeedPage> {
  StreamSubscription sub;
  List<Post> posts = [];
  List<MonUser> users = [];

  @override
  void initState() {
    super.initState();
    setupSub();
  }

  @override
  void dispose() {
    sub.cancel();
   // sub.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext build, bool scrolled) {
          return [
            MyAppBar(title: "Fil d'Actualités", image: homeImage),
          ];
        },
        body: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (BuildContext context, int index) {
            // je recupere un post
            Post post = posts[index];
            //je recuperer un user qui fait le poste
            MonUser user = users.singleWhere((u) => u.uid == post.userId);
            return PostTile(
              post: post,
              user: user,
              detail: false,
            );
          },
        ),
      ),
    );
  }

  setupSub() {
    //je recupere les users que je follow
    sub = FireHelper()
        .fireUser
        .where(keyFollowers, arrayContains: me.uid)
        .snapshots()
        .listen((datas) {
      getUsers(datas.docs);
      // ensuite je recupere les postes quils font et que je fais aussi
      datas.docs.forEach((docPost) {
        docPost.reference.collection("posts").snapshots().listen((poste) {
          setState(() {
            posts = getPost(poste.docs);
          });
        });
      });
    });
  }

//liste des users
  getUsers(List<DocumentSnapshot> userDocs) {
    List<MonUser> myList = users;
    userDocs.forEach((u) {
      MonUser user = MonUser(u);
      // je verifie que les users sont different puis j'ajoute a la liste des users
      if (myList.every((p) => p.uid != user.uid)) {
        myList.add(user);
      } else {
        // je recupere le user et je le supprime et je rajoute
        MonUser toBeChanged = myList.singleWhere((p) => p.uid == user.uid);
        myList.remove(toBeChanged);
        myList.add(user);
      }
    });
    setState(() {
      users = myList;
    });
  }

  //liste des postes
  List<Post> getPost(List<DocumentSnapshot> postDocu) {
    List<Post> myList = posts;
    // var postDocu = poste.docs;
    postDocu.forEach((p) {
      Post post = Post(p);
      // je verifie que les postes ont des different id puis j'ajoute a la liste des postes
      if (myList.every((p) => p.documentID != post.documentID)) {
        myList.add(post);
      } else {
        // je recupere le poste et je le supprime et je rajoute
        Post toBeChanged =
            myList.singleWhere((p) => p.documentID == post.documentID);
        myList.remove(toBeChanged);
        myList.add(post);
      }
    });
    myList.sort((a, b) => b.date.compareTo(a.date));
    return myList;
  }
}
