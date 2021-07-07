import 'package:flutter/material.dart';
import 'package:sy_rezosocial/view/my_material.dart';

class Menu2Items extends StatelessWidget {
  final String item1;
  final String item2;
  final PageController pageController;

  Menu2Items(
      {@required this.item1,
      @required this.item2,
      @required this.pageController});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: BoxDecoration(
          color: pointer,
          borderRadius: BorderRadius.all(Radius.circular(25.0))),
      child: CustomPaint(
        painter: MyPainter(pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[itemBouton(item1), itemBouton(item2)],
        ),
      ),
    );
  }

  //je ceer des boutons expanded(qui s'elargissent et prennent presque tout l'ecran)
  Expanded itemBouton(String name) {
    return Expanded(
      child: TextButton(
        onPressed: () {
          //si on es a la page 0 alors on passe a la page 1 sinon c'est l'inverse
          int page = (pageController.page == 0) ? 1 : 0;
          pageController.animateToPage(page,
              duration: Duration(milliseconds: 500), curve: Curves.decelerate);
        },
        child: Text(name),
      ),
    );
  }
}
