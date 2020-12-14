import 'package:flutter/material.dart';

import '../../../domain/entities/release.dart';
import '../../../../locale/generated/l10n.dart';

class SourceChooserDialog extends StatelessWidget {
  final List<Release> releases;

  const SourceChooserDialog({Key key, @required this.releases})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('${TR.of(context).source_chooser_title}:'),
      children: releases
          .map((release) => _buildDialogOption(context, release))
          .toList(),
    );
  }

  Widget _buildDialogOption(BuildContext context, Release release) {
    String text = release.group.toUpperCase();
    if (release.resolution != null) {
      text += ' ${release.resolution}p';
    }

    final dialog = SimpleDialogOption(
      child: Row(
        children: <Widget>[
          Icon(
            Icons.ondemand_video,
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

    return dialog;
  }
}
