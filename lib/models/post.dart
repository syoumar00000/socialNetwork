//import 'package:firebase_storage/firebase_storage.dart';
import 'package:sy_rezosocial/view/my_material.dart';
import 'monuser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  DocumentReference ref;
  String documentID;
  String ide;
  String text;
  String userId;
  String imageUrl;
  int date;
  List<dynamic> likes;
  List<dynamic> comments;

  Post(DocumentSnapshot snapshot) {
    ref = snapshot.reference;
    documentID = snapshot.id;
    Map<String, dynamic> map = snapshot.data();
    ide = map[keyPostId];
    text = map[keyText];
    userId = map[keyUid];
    imageUrl = map[keyImageUrl];
    date = map[keyDate];
    likes = map[keyLikes];
    comments = map[keyComments];
  }
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      keyPostId: ide,
      keyUid: userId,
      keyDate: date,
      keyLikes: likes,
      keyComments: comments
    };
    if (text != null) {
      map[keyText] = text;
    }
    if (imageUrl != null) {
      map[keyImageUrl] = imageUrl;
    }
    return map;
  }
}
