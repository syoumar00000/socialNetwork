import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sy_rezosocial/util/date_helper.dart';
import 'package:sy_rezosocial/view/my_widgets/constants.dart';

class MyNotification {
  DocumentReference notifRef;
  String text;
  String date;
  String userId;
  DocumentReference ref;
  bool seen;
  String type;

  MyNotification(DocumentSnapshot snap) {
    Map<String, dynamic> map = snap.data();
    notifRef = snap.reference;
    text = map[keyText];
    date = DateHelper().myDate(map[keyDate]);
    userId = map[keyUid];
    ref = map[keyRef];
    seen = map[keySeen];
    type = map[keyType];
  }
}
