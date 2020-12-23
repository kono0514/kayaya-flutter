import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RoundedCachedNetworkImage extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final Color placeholderColor;
  final bool adaptiveColor;
  final BoxShadow boxShadow;
  final Widget child;
  final Clip childClipBehavior;
  final Border border;

  /// TODO: Assert Can't specify both adaptiveColor = true and placeholderColor
  const RoundedCachedNetworkImage({
    Key key,
    @required this.url,
    this.width,
    this.height,
    this.child,
    this.placeholderColor,
    this.adaptiveColor = false,
    this.boxShadow,
    this.childClipBehavior = Clip.none,
    this.border,
  }) : super(key: key);

  Widget _generatePlaceholder(BuildContext context) {
    Color color = Colors.black;
    if (adaptiveColor) {
      color = Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white;
    } else if (placeholderColor != null) {
      color = placeholderColor;
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (url == null) {
      return _generatePlaceholder(context);
    }

    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) => _generatePlaceholder(context),
      imageBuilder: (context, imageProvider) => Container(
        width: width ?? MediaQuery.of(context).size.width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
          border: border,
          boxShadow: boxShadow == null ? null : [boxShadow],
        ),
        clipBehavior: childClipBehavior,
        child: child,
      ),
    );
  }
}
