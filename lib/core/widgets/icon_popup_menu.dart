import 'package:flutter/material.dart';

class IconPopupMenu extends StatelessWidget {
  final List<PopupMenuItem> items;
  final dynamic initialValue;
  final void Function(dynamic) onSelected;
  final String title;
  final Icon icon;

  const IconPopupMenu({
    Key key,
    @required this.items,
    this.initialValue,
    this.onSelected,
    @required this.title,
    this.icon,
  })  : assert(items != null && items.length > 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      offset: Offset(32.0, 0.0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 4, 8, 4),
        child: Row(
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconTheme(
                  data: IconThemeData(color: Colors.grey),
                  child: icon,
                ),
              ),
            Text(title),
            SizedBox(width: 8.0),
            Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.grey.shade700,
            ),
          ],
        ),
      ),
      itemBuilder: (context) => items,
      initialValue: initialValue ?? items.first.value,
      onSelected: onSelected,
    );
  }
}
