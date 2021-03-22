import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'controller/log_controller.dart';
import 'controller/main_app_controller.dart';
import 'package:firebase_core/firebase_core.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //FirebaseAuth.instance.authStateChanges();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _handleAuth(),
    );
  }
  //fonction  qui gere l'authentification
   Widget _handleAuth() {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot){
        return (!snapshot.hasData) ? LogController() : MainAppController(snapshot.data.uid);
      },
    );
   }
}
