import 'package:flutter/material.dart';
import 'package:sy_rezosocial/models/monuser.dart';

//User Global
MonUser me;
//creation de constantes de couleurs afin de les utiliser dans tout mon projet
const Color white = const Color(0xFFFFFFFF);
const Color base = const Color(0xFFBDBDBD);
const Color baseAccent = const Color(0xFF616161);
const Color pointer = const Color(0xFFF44336);

//creation de constantes d'images afin de les utiliser dans tout mon projet
AssetImage logoImage = AssetImage("assets/darkBee.png");
AssetImage eventImage = AssetImage("assets/event.jpg");
AssetImage homeImage = AssetImage("assets/home.jpg");
AssetImage profileImage = AssetImage("assets/profile.jpg");

//icons
Icon homeIcon = Icon(Icons.home);
Icon friendsIcon = Icon(Icons.group);
Icon notifIcon = Icon(Icons.notifications);
Icon profilIcon = Icon(Icons.account_circle);
Icon writeIcon = Icon(Icons.border_color);
Icon sendIcon = Icon(Icons.send);
Icon camIcon = Icon(Icons.camera_enhance);
Icon libraryIcon = Icon(Icons.photo_library);
Icon likeEmpty = Icon(Icons.favorite_border);
Icon likeFull = Icon(Icons.favorite);
Icon msgIcon = Icon(Icons.message);
Icon settingsIcon = Icon(Icons.settings);

//keys
String keyName = "name";
String keySurname = "surname";
String keyFollowers = "followers";
String keyFollowing = "following";
String keyImageUrl = "imageUrl";
String keyUid = "uid";
String keyPostId = "postID";
String keyText = "text";
String keyDate = "date";
String keyLikes = "likes";
String keyComments = "comments";
String keyDescription = "description";
