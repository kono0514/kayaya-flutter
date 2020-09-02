import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RoundedCachedNetworkImage extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final Color placeholderColor;
  final BoxShadow boxShadow;
  final Widget child;
  final Clip childClipBehavior;

  const RoundedCachedNetworkImage(
      {Key key,
      @required this.url,
      @required this.width,
      @required this.height,
      this.child,
      this.placeholderColor,
      this.boxShadow,
      this.childClipBehavior = Clip.none})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) => placeholderColor == null
          ? null
          : Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: placeholderColor,
              ),
            ),
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
          boxShadow: boxShadow == null ? null : [boxShadow],
        ),
        child: child,
        clipBehavior: childClipBehavior,
      ),
    );
  }
}
