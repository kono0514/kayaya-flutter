import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kayaya_flutter/locale/generated/l10n.dart';
import 'package:kayaya_flutter/search/search.dart';
import 'package:kayaya_flutter/utils/hex_color.dart';

class SearchResultListItem extends StatelessWidget {
  final SearchResultItem item;
  final Function(SearchResultItem) onTap;

  const SearchResultListItem({
    Key key,
    @required this.item,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String currentLanguage = Localizations.localeOf(context).languageCode;
    final itemName = currentLanguage == 'mn' ? item.nameMn : item.nameEn;

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
              imageUrl: item.coverImageLarge,
              placeholder: (context, url) => Container(
                color: HexColor(item.coverColor ?? '#000000'),
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
                      if (item.startYear != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Text(
                            '(${item.startYear})',
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(fontSize: 13),
                          ),
                        ),
                      Text(
                        item.animeType == 'series'
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
