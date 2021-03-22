import 'package:flutter/material.dart';
import 'package:sy_rezosocial/view/my_material.dart';
import 'dart:async';
import 'package:sy_rezosocial/util/fire_helper.dart';
import 'package:sy_rezosocial/models/monuser.dart';
import 'package:sy_rezosocial/view/page/feed_page.dart';
import 'package:sy_rezosocial/view/page/new_post_page.dart';
import 'package:sy_rezosocial/view/page/notif_page.dart';
import 'package:sy_rezosocial/view/page/profil_page.dart';
import 'package:sy_rezosocial/view/page/users_page.dart';

class MainAppController extends StatefulWidget {
  String uid;
  MainAppController(this.uid);
  _MainState  createState() => _MainState();
}

class _MainState extends State<MainAppController> {
  GlobalKey<ScaffoldState> _globalkey = GlobalKey<ScaffoldState>();
  StreamSubscription streamListener;
  int index = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //creer une souscription au stream
    streamListener = FireHelper().fire_user.doc(widget.uid).snapshots().listen((doc) {
      setState(() {
        me = MonUser(doc);
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //arreter le stream
    streamListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return (me == null) ? LoadingScaffold() : Scaffold(
      key: _globalkey,
      backgroundColor: base,
      bottomNavigationBar: BottomBar(items: [
        BarItem(icon: homeIcon, onPressed: (()=>buttonselected(0)), selected: index == 0),
        BarItem(icon: friendsIcon, onPressed: (()=>buttonselected(1)), selected: index == 1),
        Container(width:0.0, height:0.0),
        BarItem(icon: notifIcon, onPressed: (()=>buttonselected(2)), selected: index == 2),
        BarItem(icon: profilIcon, onPressed: (()=>buttonselected(3)), selected: index == 3),
      ],),
      body:showPage(),
        floatingActionButton: FloatingActionButton(onPressed: write,child: writeIcon,backgroundColor: pointer,),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  write() {
  _globalkey.currentState.showBottomSheet((builder) => NewPost());
}
  buttonselected(int index){
    print(index);
    setState(() {
      this.index = index;
    });
}

Widget showPage() {
    switch (index) {
      case 0 : return FeedPage();
      case 1 : return UsersPage();
      case 2 : return NotifPage();
      default: return ProfilPage();
    }
}
}