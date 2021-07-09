import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/material.dart';

// class pour pouvoir ecrire mes propres textes
class MyText extends DetectableText {
  MyText(data,
      {TextAlign alignment: TextAlign.center,
      double fontSize: 17.0,
      FontStyle style: FontStyle.normal,
      Function tap,
      Color color: Colors.white})
      : super(
          text: data,
          detectedStyle: TextStyle(
            fontSize: 20,
            color: Colors.green,
            decoration: TextDecoration.underline,
          ),
          basicStyle:
              TextStyle(fontSize: fontSize, fontStyle: style, color: color),
          detectionRegExp: detectionRegExp(url: true),
          onTap: tap,
          // data,
          textAlign: alignment,
          // style: TextStyle(fontSize: fontSize, fontStyle: style, color: color),
        );
}
