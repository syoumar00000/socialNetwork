import 'package:flutter/material.dart';
import 'package:sy_rezosocial/view/my_material.dart';

class ButtonGradient extends Card{
  ButtonGradient({
    double elevation: 7.5,
    @required VoidCallback callback,
    double height: 50.0,
    width:300.0,
    @required String text,
  }): super (
    elevation: elevation,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(height / 2)),
    child: Container(
      height: height,
      width: width,
      decoration: MyGradient(startColor: baseAccent, endColor: base, radius: height / 2, horizontal: true),
      child: FlatButton(
        onPressed: callback,
        child: MyText(text),
      ),
    ),
  );
}
