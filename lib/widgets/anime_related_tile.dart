import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kayaya_flutter/api/graphql_api.graphql.dart';
import 'package:kayaya_flutter/hex_color.dart';
import 'package:kayaya_flutter/widgets/rounded_cached_network_image.dart';

class AnimeRelatedTile extends StatelessWidget {
  final ListItemAnimeMixin anime;
  final double height;
  final VoidCallback onPressed;

  const AnimeRelatedTile({Key key, this.anime, this.onPressed, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: RoundedCachedNetworkImage(
        url: anime.coverImage.large,
        width: height != null ? (height / 1.5).roundToDouble() : 109,
        height: height ?? 163,
        placeholderColor: HexColor(
          anime.coverColor ?? "#000000",
        ),
        childClipBehavior: Clip.hardEdge,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: SizedBox(
            width: double.infinity,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 10.0),
                  child: Text(
                    anime.name.mn,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
