import 'package:flutter/material.dart';

// https://github.com/figengungor/clippy_flutter/blob/master/lib/src/arc_clipper.dart
class SeekRectangleArcClipper extends CustomClipper<Path> {
  final AxisDirection side;
  final double height;

  SeekRectangleArcClipper({@required this.side, this.height = 25.0});

  @override
  Path getClip(Size size) {
    switch (side) {
      case AxisDirection.up:
        return _getTopPath(size);
      case AxisDirection.right:
        return _getRightPath(size);
      case AxisDirection.down:
        return _getBottomPath(size);
      case AxisDirection.left:
        return _getLeftPath(size);
      default:
        return _getRightPath(size);
    }
  }

  Path _getBottomPath(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - height);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height);
    path.quadraticBezierTo(
        size.width * 3 / 4, size.height, size.width, size.height - height);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  Path _getTopPath(Size size) {
    var path = Path();
    path.moveTo(0.0, height);

    path.quadraticBezierTo(size.width / 4, 0.0, size.width / 2, 0.0);
    path.quadraticBezierTo(size.width * 3 / 4, 0.0, size.width, height);

    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();

    return path;
  }

  Path _getLeftPath(Size size) {
    var path = Path();
    path.moveTo(height, 0.0);

    path.quadraticBezierTo(0.0, size.height / 4, 0.0, size.height / 2);
    path.quadraticBezierTo(0.0, size.height * 3 / 4, height, size.height);

    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  Path _getRightPath(Size size) {
    var path = Path();
    path.moveTo(size.width - height, 0.0);

    path.quadraticBezierTo(
        size.width, size.height / 4, size.width, size.height / 2);
    path.quadraticBezierTo(
        size.width, size.height * 3 / 4, size.width - height, size.height);

    path.lineTo(0.0, size.height);
    path.lineTo(0.0, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    SeekRectangleArcClipper oldie = oldClipper as SeekRectangleArcClipper;
    return height != oldie.height || side != oldie.side;
  }
}
