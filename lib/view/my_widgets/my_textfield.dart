import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:flutter/material.dart';

class MyTextField extends DetectableTextField {
  MyTextField(
      {@required TextEditingController controller,
      TextInputType type: TextInputType.text,
      String hint: "",
      Icon icon,
      detectedStyle: true,
      bool obscure: false //permet de cacher la saisie du password
      })
      : super(
          detectionRegExp: detectionRegExp(),
          decoratedStyle: TextStyle(
            color: Colors.green,
            decoration: TextDecoration.underline,
          ),
          controller: controller,
          keyboardType: type,
          obscureText: obscure,
          decoration: InputDecoration(hintText: hint, icon: icon),
        );
}

/* class MyTextField extends TextField {
  MyTextField({
  @required TextEditingController controller,
    TextInputType type: TextInputType.text,
    String hint: "",
    Icon icon,
    bool obscure: false //permet de cacher la saisie du password
  }): super(
    controller: controller,
    keyboardType: type,
    obscureText: obscure,
    decoration: InputDecoration(
      hintText: hint,
      icon: icon
    ),
  );
} */
