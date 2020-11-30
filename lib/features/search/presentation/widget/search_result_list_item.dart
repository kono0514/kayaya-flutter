import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../locale/generated/l10n.dart';
import '../../../../utils/hex_color.dart';
import '../../domain/entity/search_result.dart';

class SearchResultListItem extends StatelessWidget {
  final SearchResult item;
  final Function(SearchResult) onTap;

  const SearchResultListItem({
    Key key,
    @required this.item,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: read from pref
    String currentLanguage = Localizations.localeOf(context).languageCode;
    final itemName = currentLanguage == 'mn' ? item.name : item.name;

    return InkWell(
      onTap: () => onTap(item),
      child: Container(
        height: 112,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            CachedNetworkImage(
              width: 64,
              height: 96,
              imageUrl: item.image,
              placeholder: (context, url) => Container(
                color: HexColor(item.color ?? '#000000'),
              ),
            ),
            SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    itemName,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      if (item.year != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Text(
                            '(${item.year})',
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(fontSize: 13),
                          ),
                        ),
                      Text(
                        item.type == 'series'
                            ? TR.of(context).series
                            : TR.of(context).movie,
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .copyWith(fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
