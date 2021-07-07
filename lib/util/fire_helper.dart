import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sy_rezosocial/models/monuser.dart';
import 'package:sy_rezosocial/models/post.dart';
import 'package:sy_rezosocial/view/my_material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FireHelper {
  //authentification (Auth)
  final authInstance = FirebaseAuth.instance;
  //creation de trois methodes pour s'authentifier
  // 1 s'authenfier avec un user qui existe deja
  Future<User> signIn(String mail, String pwd) async {
    final User user = (await authInstance.signInWithEmailAndPassword(
            email: mail, password: pwd))
        .user;
    return user;
  }

  //2 pour s'authenfier avec un user qui n'existe pas encore d'ou il s'inscrire
  Future<User> createAccount(
      String mail, String pwd, String name, String surname) async {
    final User user = (await authInstance.createUserWithEmailAndPassword(
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
  logOut() => authInstance.signOut();
  //fin authentification

  //base de données
  // la cle d'entree dans ma bdd
  static final dataInstance = FirebaseFirestore.instance;
  // la cle d'entree dans mes users
  final fireUser = dataInstance.collection("users");
  // la cle d'entree dans mes notifications
  final fireNotif = dataInstance.collection("notifications");

  //methode pour envoyer une notification
  //from(qui envoie la notif)
  //to( a qui envoyé  la notif)
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
    fireNotif.doc(to).collection("SingleNotif").add(map);
  }

  //methode pour ajouter un user
  addUser(String uid, Map<String, dynamic> map) {
    fireUser.doc(uid).set(map);
  }

  //methode pour modifier un user
  modifyUser(Map<String, dynamic> data) {
    fireUser.doc(me.uid).update(data);
  }

  // methode pour modifier la photo de profil de l'utilisateur
  modifyPhoto(File file) {
    Reference ref = storageUser.child(me.uid);
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
      Reference ref = storagePosts.child(uid).child(date.toString());
      addImage(file, ref).then((finalised) {
        String imageUrl = finalised;
        map[keyImageUrl] = imageUrl;
        fireUser.doc(uid).collection("posts").doc().set(map);
      });
    } else {
      fireUser.doc(uid).collection("posts").doc().set(map);
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
      fireUser.doc(uid).collection("posts").snapshots();
  // fin function stream

  //stockage
  static final storageInstance = FirebaseStorage.instance.ref();
  final storageUser = storageInstance.child("users");
  final storagePosts = storageInstance.child("posts");

  Future<String> addImage(File file, Reference ref) async {
    UploadTask task = ref.putFile(file);
    TaskSnapshot snapshot = await task.whenComplete(() => ref.getDownloadURL());
    String urlString = await snapshot.ref.getDownloadURL();
    return urlString;
  }
}
