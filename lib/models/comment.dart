import 'package:sy_rezosocial/view/my_material.dart';
import 'package:sy_rezosocial/util/date_helper.dart';

class Comment {
  String userId;
  String text;
  String date;

  Comment(Map<dynamic, dynamic> map) {
    userId = map[keyUid];
    text = map[keyText];
    date = DateHelper().myDate(map[keyDate]);
  }
}
