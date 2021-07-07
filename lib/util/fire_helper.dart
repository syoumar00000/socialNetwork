import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sy_rezosocial/models/monuser.dart';
import 'package:sy_rezosocial/models/post.dart';
import 'package:sy_rezosocial/view/my_material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FireHelper {
  //authentification (Auth)
  final auth_instance = FirebaseAuth.instance;
  //creation de trois methodes pour s'authentifier
  // 1 s'authenfier avec un user qui existe deja
  Future<User> signIn(String mail, String pwd) async {
    final User user = (await auth_instance.signInWithEmailAndPassword(
            email: mail, password: pwd))
        .user;
    return user;
  }

  //2 pour s'authenfier avec un user qui n'existe pas encore d'ou il s'inscrire
  Future<User> createAccount(
      String mail, String pwd, String name, String surname) async {
    final User user = (await auth_instance.createUserWithEmailAndPassword(
            email: mail, password: pwd))
        .user;
    //creer le user afin de l'ajouter dans la bdd
    String uid = user.uid;
    List<dynamic> followers = [uid];
    List<dynamic> following = [];
    Map<String, dynamic> map = {
      keyName: name,
      keySurname: surname,
      keyFollowers: followers,
      keyFollowing: following,
      keyImageUrl: "",
      keyUid: uid
    };
    addUser(uid, map);
    return user;
  }

  //3 pour un logout
  logOut() => auth_instance.signOut();
  //fin authentification

  //base de données
  // la cle d'entree dans ma bdd
  static final data_instance = FirebaseFirestore.instance;
  // la cle d'entree dans mes users
  final fire_user = data_instance.collection("users");
  // la cle d'entree dans mes notifications
  final fire_notif = data_instance.collection("notifications");

  //methode pour envoyer une notification
  //from(qui envoie la notif)
  //from( a qui envoyé  la notif)
  // le texte de la notif
  addNotification(
      String from, String to, String text, DocumentReference ref, String type) {
    Map<String, dynamic> map = {
      keyUid: from,
      keyText: text,
      keyType: type,
      keyRef: ref,
      keySeen: false,
      keyDate: DateTime.now().millisecondsSinceEpoch.toInt(),
    };
    fire_notif.doc(to).collection("SingleNotif").add(map);
  }

  //methode pour ajouter un user
  addUser(String uid, Map<String, dynamic> map) {
    fire_user.doc(uid).set(map);
  }

  //methode pour modifier un user
  modifyUser(Map<String, dynamic> data) {
    fire_user.doc(me.uid).update(data);
  }

  // methode pour modifier la photo de profil de l'utilisateur
  modifyPhoto(File file) {
    //assert(file.existsSync());
    Reference ref = storage_user.child(me.uid);
    /* addImageModified(file, ref).then((finalised) {
      Map<String, dynamic> data = {keyImageUrl: finalised};
      modifyUser(data);
    }); */
    addImage(file, ref).then((finalised) {
      Map<String, dynamic> data = {keyImageUrl: finalised};
      modifyUser(data);
    });
  }

  //ajouter un follower ou supprimer un
  addFollow(MonUser other) {
    if (me.following.contains(other.uid)) {
      //si je le suit  alors je le supprime de ma face
      me.ref.update({
        keyFollowing: FieldValue.arrayRemove([other.uid])
      });
      //et je supprime de sa face aussi
      other.ref.update({
        keyFollowers: FieldValue.arrayRemove([me.uid])
      });
    } else {
      //si je ne le suit pas  alors je le suit et l'affiche a ma face
      me.ref.update({
        keyFollowing: FieldValue.arrayUnion([other.uid])
      });
      // et je lui montre a sa face aussi
      other.ref.update({
        keyFollowers: FieldValue.arrayUnion([me.uid])
      });
      //envoie de notif quand on suit un user
      addNotification(me.uid, other.uid,
          "${me.surname} a commencé a vous suivre .", me.ref, keyFollowers);
    }
  }

  //ajouter like ou retirer un like par rapport a un post
  addLike(Post post) {
    //si jai  deja liker ce poste alors je supprime
    if (post.likes.contains(me.uid)) {
      post.ref.update({
        keyLikes: FieldValue.arrayRemove([me.uid])
      });
    } else {
      // sinon je like
      post.ref.update({
        keyLikes: FieldValue.arrayUnion([me.uid])
      });
      //envoie de notif quand on aime un poste
      addNotification(me.uid, post.userId, "${me.surname} a aimé votre poste.",
          post.ref, keyLikes);
    }
  }

  addPost(String uid, String text, File file) {
    int date = DateTime.now().millisecondsSinceEpoch.toInt();
    List<dynamic> likes = [];
    List<dynamic> comments = [];
    Map<String, dynamic> map = {
      keyUid: uid,
      keyLikes: likes,
      keyComments: comments,
      keyDate: date
    };
    if (text != null && text != "") {
      map[keyText] = text;
    }
    if (file != null) {
      //assert(file.existsSync());
      Reference ref = storage_posts.child(uid).child(date.toString());
      addImage(file, ref).then((finalised) {
        String imageUrl = finalised;
        map[keyImageUrl] = imageUrl;
        fire_user.doc(uid).collection("posts").doc().set(map);
      });
    } else {
      fire_user.doc(uid).collection("posts").doc().set(map);
    }
  }

  //ajouter un commentaire
  addComment(DocumentReference ref, String text, String postOwner) {
    Map<dynamic, dynamic> map = {
      keyUid: me.uid,
      keyText: text,
      keyDate: DateTime.now().millisecondsSinceEpoch.toInt(),
    };
    ref.update({
      keyComments: FieldValue.arrayUnion([map])
    });
    //envoie de notif quand on comment un poste
    addNotification(me.uid, postOwner, "${me.surname} a commenté votre poste.",
        ref, keyComments);
  }
  //fin base de donnée

  //function stream
  Stream<QuerySnapshot> postFrom(String uid) =>
      fire_user.doc(uid).collection("posts").snapshots();
  // fin function stream

  //stockage
  static final storage_instance = FirebaseStorage.instance.ref();
  final storage_user = storage_instance.child("users");
  final storage_posts = storage_instance.child("posts");

  Future<String> addImage(File file, Reference ref) async {
    //assert(file.existsSync());
    UploadTask task = ref.putFile(file);
    TaskSnapshot snapshot = await task.whenComplete(() => ref.getDownloadURL());
    String urlString = await snapshot.ref.getDownloadURL();
    return urlString;
  }
}
