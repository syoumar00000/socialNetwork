import 'package:flutter/material.dart';
import 'package:sy_rezosocial/models/monuser.dart';
import 'package:sy_rezosocial/view/my_material.dart';

class UsersPage extends StatefulWidget{
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<UsersPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: MyText("liste utilisateurs"),
    );
  }
}