import 'package:flutter/material.dart';
import 'package:sy_rezosocial/util/fire_helper.dart';
import 'package:sy_rezosocial/view/my_material.dart';
import 'package:flutter/cupertino.dart';

class AlertHelper {
  Future<void> error(BuildContext context, String error) async {
    MyText title = MyText(
      "Erreur",
      color: Colors.black,
    );
    MyText subtitle = MyText(
      error,
      color: Colors.black,
    );
    // await Future.delayed(Duration(seconds: 1), (){
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext ctx) {
          return (Theme.of(context).platform == TargetPlatform.iOS)
              ? CupertinoAlertDialog(
                  title: title, content: subtitle, actions: [close(ctx, "OK")])
              : AlertDialog(
                  title: title,
                  content: subtitle,
                  actions: [close(ctx, "OK")],
                );
        });
  }

  Future<void> disconnect(BuildContext context) {
    MyText title = MyText("Voulez-vous vous déconnecter ?", color: baseAccent);
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return (Theme.of(context).platform == TargetPlatform.iOS)
              ? CupertinoAlertDialog(
                  title: title,
                  actions: <Widget>[
                    close(ctx, "NON"),
                    deconnectBtn(ctx),
                  ],
                )
              : AlertDialog(
                  title: title,
                  actions: <Widget>[
                    close(ctx, "NON"),
                    deconnectBtn(ctx),
                  ],
                );
        });
  }

  //modification des infos de l'utilisateur
  Future<void> modifUserAlert(BuildContext context,
      {@required TextEditingController name,
      @required TextEditingController surname,
      @required TextEditingController desc}) async {
    MyTextField nameModify = MyTextField(
      controller: name,
      hint: me.name,
    );
    MyTextField surnameModify = MyTextField(
      controller: surname,
      hint: me.surname,
    );
    MyTextField descModify = MyTextField(
      controller: desc,
      hint: me.description ?? "Aucune description",
    );
    MyText title = MyText(
      "Changer les données de l'utilisateur ",
      color: pointer,
    );
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return (Theme.of(context).platform == TargetPlatform.iOS)
              ? CupertinoAlertDialog(
                  title: title,
                  content: Column(
                    children: <Widget>[nameModify, surnameModify, descModify],
                  ),
                  actions: <Widget>[
                    close(ctx, "Annulez"),
                    TextButton(
                      onPressed: () {
                        Map<String, dynamic> data = {};
                        if (name.text != null && name.text != "") {
                          data[keyName] = name.text;
                        }
                        if (surname.text != null && surname.text != "") {
                          data[keySurname] = surname.text;
                        }
                        if (desc.text != null && desc.text != "") {
                          data[keyDescription] = desc.text;
                        }
                        FireHelper().modifyUser(data);
                        Navigator.pop(context);
                      },
                      child: MyText(
                        "Valider",
                        color: Colors.blue,
                      ),
                    ),
                  ],
                )
              : AlertDialog(
                  title: title,
                  content: Column(
                    children: <Widget>[nameModify, surnameModify, descModify],
                  ),
                  actions: <Widget>[
                    close(ctx, "Annulez"),
                    TextButton(
                      onPressed: () {
                        Map<String, dynamic> data = {};
                        if (name.text != null && name.text != "") {
                          data[keyName] = name.text;
                        }
                        if (surname.text != null && surname.text != "") {
                          data[keySurname] = surname.text;
                        }
                        if (desc.text != null && desc.text != "") {
                          data[keyDescription] = desc.text;
                        }
                        FireHelper().modifyUser(data);
                        Navigator.pop(context);
                      },
                      child: MyText(
                        "Valider",
                        color: Colors.blue,
                      ),
                    ),
                  ],
                );
        });
  }

  //bouton pour deconnection
  TextButton deconnectBtn(BuildContext ctx) {
    return TextButton(
      onPressed: () {
        FireHelper().logOut();
        Navigator.pop(ctx);
      },
      child: MyText(
        "OUI",
        color: Colors.blue,
      ),
    );
  }

  //bouton pour fermeture
  TextButton close(BuildContext ctx, String text) {
    return TextButton(
      onPressed: () {
        Navigator.pop(ctx);
      },
      child: MyText(
        text,
        color: pointer,
      ),
    );
  }
}
