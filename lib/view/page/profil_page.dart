import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sy_rezosocial/models/post.dart';
import 'package:sy_rezosocial/util/alert_helper.dart';
import 'package:sy_rezosocial/view/my_material.dart';
import 'package:sy_rezosocial/models/monuser.dart';
import 'package:sy_rezosocial/util/fire_helper.dart';
import 'package:sy_rezosocial/delegate/header_delegate.dart';
import 'package:sy_rezosocial/view/tiles/postTiles.dart';
import 'package:image_picker/image_picker.dart';

class ProfilPage extends StatefulWidget {
  MonUser user;
  ProfilPage(this.user);

  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<ProfilPage> {
  bool isMe = false;
  ScrollController controller;
  double expanded = 200.0;
  TextEditingController _name;
  TextEditingController _surname;
  TextEditingController _desc;
  bool get _showTitle {
    return controller.hasClients &&
        controller.offset > expanded - kToolbarHeight;
  }

  StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    isMe = (widget.user.uid == me.uid);
    controller = ScrollController()
      ..addListener(() {
        setState(() {});
      });
    _name = TextEditingController();
    _surname = TextEditingController();
    _desc = TextEditingController();
    // subscription permet decouter automatiquement les modif sur lutilisateur et de le mettre a jour
    subscription =
        FireHelper().fireUser.doc(widget.user.uid).snapshots().listen((data) {
      setState(() {
        widget.user = MonUser(data);
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _name.dispose();
    _surname.dispose();
    _desc.dispose();
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FireHelper().postFrom(widget.user.uid),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return LoadingCenter();
        } else {
          List<DocumentSnapshot> myDocuments = snapshot.data.docs;
          return CustomScrollView(
            controller: controller,
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                expandedHeight: expanded,
                actions: <Widget>[
                  (isMe)
                      ? IconButton(
                          color: pointer,
                          onPressed: () => AlertHelper().disconnect(context),
                          icon: settingsIcon)
                      : FollowButton(user: widget.user)
                ],
                flexibleSpace: FlexibleSpaceBar(
                  title: _showTitle
                      ? MyText(widget.user.surname + " " + widget.user.name)
                      : MyText(""),
                  background: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: profileImage, fit: BoxFit.cover),
                    ),
                    child: Center(
                      child: ProfilImage(
                        urlString: widget.user.imageUrl,
                        size: 75.0,
                        onPressed: changePhotoProfil,
                      ),
                    ),
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: MyHeader(
                    user: widget.user,
                    callback: changeDataFields,
                    scrolled: _showTitle),
              ),
              SliverList(delegate:
                  SliverChildBuilderDelegate((BuildContext context, index) {
                if (index == myDocuments.length)
                  return ListTile(
                    title: MyText("Fin de Liste"),
                  );
                if (index > myDocuments.length) return null;
                Post post = Post(myDocuments[index]);
                return PostTile(post: post, user: widget.user);
              }))
            ],
          );
        }
      },
    );
  }

  //function pour changer les donnees de l'utilisateur
  void changeDataFields() {
    AlertHelper()
        .modifUserAlert(context, name: _name, surname: _surname, desc: _desc);
  }

  //modal changement de photo de profil
  void changePhotoProfil() {
    if (widget.user.uid == me.uid) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext ctx) {
            return Container(
              height: 150.0,
              child: Card(
                elevation: 5.0,
                margin: EdgeInsets.only(
                    top: 10.0, right: 10.0, left: 10.0, bottom: 25.0),
                child: Container(
                  color: base,
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: MyText("Modification de la photo de profil"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconButton(
                                color: pointer,
                                onPressed: () {
                                  takePhoto(ImageSource.camera);
                                  Navigator.pop(ctx);
                                },
                                icon: camIcon),
                            IconButton(
                                color: pointer,
                                onPressed: () {
                                  takePhoto(ImageSource.gallery);
                                  Navigator.pop(ctx);
                                },
                                icon: libraryIcon),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
    }
  }

  Future<void> takePhoto(ImageSource source) async {
    var file = await ImagePicker()
        .getImage(source: source, maxWidth: 500.0, maxHeight: 500.0);
    FireHelper().modifyPhoto(File(file.path));
  }

  validate() {}
}
