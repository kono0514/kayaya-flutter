import 'dart:math';

import 'package:flutter/material.dart';

class RatingBar extends StatelessWidget {
  final int rating;
  final double size;
  final Color color;

  const RatingBar(
      {Key key, @required this.rating, @required this.size, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _fiveStarRating = min(rating ?? 0, 100) / 20;
    int _wholeStars = _fiveStarRating.floor();
    bool _withHalfStar = _fiveStarRating.remainder(1) > 0;
    List<Widget> items = [];

    items.addAll(
      List.generate(
        _wholeStars,
        (index) => Icon(
          Icons.star,
          color: color ?? Colors.yellow,
          size: size,
        ),
      ),
    );

    if (_withHalfStar) {
      items.add(Icon(
        Icons.star_half,
        color: color ?? Colors.yellow,
        size: size,
      ));
    }

    items.addAll([
      SizedBox(width: 6),
      Text('${rating / 10}',
          style: Theme.of(context).textTheme.caption.copyWith(fontSize: 13)),
    ]);

    return Row(children: items);
  }
}
