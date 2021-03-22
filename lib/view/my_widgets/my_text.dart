import 'package:flutter/material.dart';
 // class pour pouvoir ecrire mes propres textes
class MyText extends Text {

  MyText(data,{
    TextAlign alignment: TextAlign.center,
    double fontSize: 17.0,
    FontStyle style: FontStyle.normal,
    Color color: Colors.white
  }): super(
    data,
    textAlign: alignment,
    style: TextStyle(
      fontSize: fontSize,
      fontStyle: style,
      color: color
    ),
  );
}