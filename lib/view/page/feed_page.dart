import 'package:flutter/material.dart';
import 'package:sy_rezosocial/models/monuser.dart';
import 'package:sy_rezosocial/view/my_material.dart';

class FeedPage extends StatefulWidget{

  _FeedState createState() => _FeedState();
}

class _FeedState extends State<FeedPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: MyText("fil d'actualités"),
    );
  }
}