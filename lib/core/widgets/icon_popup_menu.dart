import 'package:flutter/material.dart';

class IconPopupMenu<T> extends StatelessWidget {
  final List<PopupMenuItem<T>> items;
  final T initialValue;
  final Function(T) onSelected;
  final Widget title;
  final Icon icon;
  final EdgeInsetsGeometry padding;
  final Color iconColor;

  const IconPopupMenu({
    Key key,
    @required this.items,
    this.initialValue,
    this.onSelected,
    @required this.title,
    this.icon,
    this.padding,
    this.iconColor,
  })  : assert(items != null && items.length > 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      offset: Offset(32.0, 0.0),
      child: Padding(
        padding: padding ?? const EdgeInsets.fromLTRB(0, 4, 8, 4),
        child: IconTheme(
          data: Theme.of(context).iconTheme.copyWith(color: iconColor),
          child: Row(
            children: [
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: icon,
                ),
              title,
              SizedBox(width: 8.0),
              Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
      itemBuilder: (context) => items,
      initialValue: initialValue ?? items.first.value,
      onSelected: onSelected,
    );
  }
}
