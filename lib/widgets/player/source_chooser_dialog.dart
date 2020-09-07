import 'package:flutter/material.dart';
import 'package:kayaya_flutter/api/graphql_api.graphql.dart';

class SourceChooserDialog extends StatelessWidget {
  final List<GetAnimeEpisodes$Query$Episodes$Data$Releases> releases;

  const SourceChooserDialog({Key key, @required this.releases})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Choose source:'),
      children: releases
          .map((release) => _buildDialogOption(context, release))
          .toList(),
    );
  }

  Widget _buildDialogOption(BuildContext context,
      GetAnimeEpisodes$Query$Episodes$Data$Releases release) {
    bool withTooltip = false;

    String text = release.group.toUpperCase();
    if (release.resolution != null) {
      text += ' ${release.resolution}p';
    }

    final domain = Uri.parse(release.url).host;
    if (release.type == 'embed') {
      text += ' ($domain)';
      withTooltip = true;
    }

    final dialog = SimpleDialogOption(
      child: Row(
        children: <Widget>[
          Icon(
            release.type == 'direct' ? Icons.ondemand_video : Icons.public,
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.clip,
            ),
          ),
        ],
      ),
      onPressed: () {
        Navigator.pop(context, release);
      },
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 24.0,
      ),
    );

    if (withTooltip) {
      return Tooltip(
        message: domain,
        child: dialog,
      );
    }

    return dialog;
  }
}
