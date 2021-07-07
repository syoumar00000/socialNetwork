import 'package:flutter/material.dart';
import 'package:sy_rezosocial/view/my_material.dart';
import 'package:sy_rezosocial/util/fire_helper.dart';

class LogController extends StatefulWidget {
  _LogState createState() => _LogState();
}

class _LogState extends State<LogController> {
  PageController _pageController;
  TextEditingController _mail;
  TextEditingController _pwd;
  TextEditingController _name;
  TextEditingController _surname;

  //pour lancer le state
  @override
  void initState() {
    super.initState();
    //initialisation du pagecontroller
    _pageController = PageController();
    _name = TextEditingController();
    _pwd = TextEditingController();
    _mail = TextEditingController();
    _surname = TextEditingController();
  }

  //pour arreter le state
  @override
  void dispose() {
    _pageController.dispose();
    _name.dispose();
    _mail.dispose();
    _surname.dispose();
    _pwd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          //recevoir les notifications
          overscroll.disallowGlow();
        },
        child: SingleChildScrollView(
          child: InkWell(
            onTap: (() => hideKeyboard()),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: (MediaQuery.of(context).size.height >= 650.0)
                  ? MediaQuery.of(context).size.height
                  : 650.0,
              decoration: MyGradient(startColor: base, endColor: baseAccent),
              child: SafeArea(
                child: Column(
                  children: <Widget>[
                    PaddingWith(
                        widget: Image(
                      image: logoImage,
                      height: 100.0,
                    )),
                    PaddingWith(
                      widget: Menu2Items(
                          item1: "Connection",
                          item2: "Inscription",
                          pageController: _pageController),
                      top: 20.0,
                      bottom: 20.0,
                    ),
                    //ajout dun widget qui va s'etendre(expanded)
                    Expanded(
                      flex: 2,
                      child: PageView(
                        controller: _pageController,
                        children: <Widget>[logView(0), logView(1)],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //creation widget pour gerer afficher les elements de la connection ou de l'inscription
  Widget logView(int index) {
    return Column(
      children: <Widget>[
        PaddingWith(
            widget: Card(
              elevation: 7.5,
              color: white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                margin: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: listItems((index == 0)),
                ),
              ),
            ),
            top: 15.0,
            bottom: 15.0,
            left: 20.0,
            right: 20.0),
        PaddingWith(
          top: 15.0,
          bottom: 15.0,
          widget: ButtonGradient(
              callback: signIn((index == 0)),
              text: (index == 0) ? "Se Connecter" : "S'inscrire"),
        ),
      ],
    );
  }

  //je cree une liste de widget
  List<Widget> listItems(bool exists) {
    List<Widget> list = [];
    if (!exists) {
      list.add(MyTextField(
        controller: _name,
        hint: "Entrez votre nom svp",
        type: TextInputType.text,
      ));
      list.add(MyTextField(
        controller: _surname,
        hint: "Entrez votre prenom svp",
        type: TextInputType.text,
      ));
    }
    list.add(MyTextField(
      controller: _mail,
      hint: "Entrez votre mail svp",
      type: TextInputType.emailAddress,
    ));
    list.add(MyTextField(
      controller: _pwd,
      hint: "Entrez votre mot de passe svp",
      obscure: true,
    ));
    return list;
  }

  //fonction pour inscription
  signIn(bool exists) {
    // hideKeyboard();
    if (_mail.text != null && _mail.text != "") {
      if (_pwd.text != null && _pwd.text != "") {
        if (exists) {
          //connection avec mail et pwd
          FireHelper().signIn(_mail.text, _pwd.text);
        } else {
          // verifier nom et prenom puis inscription
          if (_name.text != null && _name.text != "") {
            if (_surname.text != null && _surname.text != "") {
              //inscription
              FireHelper().createAccount(
                  _mail.text, _pwd.text, _name.text, _surname.text);
            } else {
              //alerte pas de prenom
              // await Future.delayed(Duration(seconds: 1), () {
              // AlertHelper().error(context, "Aucun prenom");
              // });
            }
          } else {
            //alerte pas de nom
            // await Future.delayed(Duration(seconds: 1), () {
            // AlertHelper().error(context, "Aucun nom");
            // });
          }
        }
      } else {
        //alerte pas de mdp
        // await Future.delayed(Duration(seconds: 1), () {
        // AlertHelper().error(context, "Aucun mot de passe");
        //});
      }
    } else {
      //alerte pas de mail
      // await Future.delayed(Duration(seconds: 1), () {
      //AlertHelper().error(context, "Aucune addresse mail");
      // });
    }
  }

  //fonction pour cacher le clavier
  hideKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
