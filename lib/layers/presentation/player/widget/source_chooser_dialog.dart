import 'package:flutter/material.dart';

import '../../../../locale/generated/l10n.dart';
import '../../../domain/entities/release.dart';

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
      onPressed: () {
        Navigator.pop(context, release);
      },
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 24.0,
      ),
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.ondemand_video,
          ),
          const SizedBox(width: 10.0),
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
    );

    return dialog;
  }
}
