import 'package:flutter/material.dart';
//je cree mes propres widgets avec des padding et margin qui auront effet sur mes images

class PaddingWith extends Padding {
  PaddingWith({
    @required  Widget widget,
    double top: 10.0,
    double left: 0.0,
    double right: 0.0,
    double bottom: 0.0
}): super(
    padding: EdgeInsets.only(
      top: top,
      left: left,
      right: right,
      bottom: bottom
    ),
    child: widget
  );
}