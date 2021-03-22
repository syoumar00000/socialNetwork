import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sy_rezosocial/view/my_widgets/constants.dart';


class MonUser {
  String uid;
  String name;
  String surname;
  String imageUrl;
  List<dynamic> followers;
  List<dynamic> following;
  DocumentReference ref;
  String documentId;

  MonUser(DocumentSnapshot snapshot) {
    ref = snapshot.reference;
    documentId = snapshot.id;
    Map<String ,dynamic> map = snapshot.data();
    uid = map[keyUid];
    name = map[keyName];
    surname = map[keySurname];
    followers = map[keyFollowers];
    following = map[keyFollowing];
    imageUrl = map[keyImageUrl];
  }

  Map<String, dynamic> toMap() {
   return {
     keyUid: uid,
     keyName: name,
     keySurname: surname,
     keyFollowers: followers,
     keyFollowing: following,
     keyImageUrl: imageUrl
   };
}

}