import 'package:flutter/material.dart';

class PlaylistItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const PlaylistItem({Key key, @required this.title, this.subtitle, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: Colors.red),
      ),
      subtitle: Text(
        subtitle ?? '',
        maxLines: 2,
      ),
      isThreeLine: true,
      onTap: onTap,
    );
  }
}
