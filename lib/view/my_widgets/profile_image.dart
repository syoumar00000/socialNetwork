import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sy_rezosocial/view/my_material.dart';

class ProfilImage extends InkWell {
  ProfilImage(
      {double size: 20.0,
      @required String urlString,
      @required VoidCallback onPressed})
      : super(
            onTap: onPressed,
            child: CircleAvatar(
              radius: size,
              backgroundImage: (urlString != null && urlString != "")
                  ? CachedNetworkImageProvider(urlString)
                  : logoImage,
              backgroundColor: white,
            ));
}
