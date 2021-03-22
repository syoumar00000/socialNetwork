import 'package:flutter/material.dart';
import 'package:sy_rezosocial/models/monuser.dart';
import 'package:sy_rezosocial/view/my_material.dart';

class ProfilPage extends StatefulWidget{

  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<ProfilPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: MyText("profils"),
    );
  }
}