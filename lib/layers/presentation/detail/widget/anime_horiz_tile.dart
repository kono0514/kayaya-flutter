import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/utils/hex_color.dart';
import '../../../../core/widgets/rounded_cached_network_image.dart';
import '../../../domain/entities/anime.dart';

class AnimeHorizTile extends StatelessWidget {
  final Anime anime;
  final double height;
  final VoidCallback onPressed;

  const AnimeHorizTile({Key key, this.anime, this.onPressed, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: RoundedCachedNetworkImage(
        url: anime.coverImage,
        width: height != null ? (height / 1.5).roundToDouble() : 109,
        height: height ?? 163,
        placeholderColor: HexColor(
          anime.coverColor ?? "#000000",
        ),
        childClipBehavior: Clip.hardEdge,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: double.infinity,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 10.0),
                  child: Text(
                    anime.name,
                    style: const TextStyle(
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
