import 'package:flutter/material.dart';
import 'package:sy_rezosocial/models/monuser.dart';
import 'package:sy_rezosocial/view/my_material.dart';

class NotifPage extends StatefulWidget{

  _NotifState createState() => _NotifState();
}

class _NotifState extends State<NotifPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: MyText("notifications"),
    );
  }
}