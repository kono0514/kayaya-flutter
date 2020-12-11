import 'package:flutter/material.dart';

class PlaylistItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isActive;

  const PlaylistItem({
    Key key,
    @required this.title,
    this.subtitle,
    this.onTap,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(
        subtitle ?? '',
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      onTap: onTap,
      selected: isActive,
    );
  }
}
