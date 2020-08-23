import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kayaya_flutter/api/graphql_api.graphql.dart';
import 'package:kayaya_flutter/cubit/browse_filter_cubit.dart';
import 'package:kayaya_flutter/cubit/genre_list_cubit.dart';
import 'package:kayaya_flutter/graphql_client.dart';
import 'package:kayaya_flutter/models/filter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:collection/collection.dart';

class FilterDialog extends StatefulWidget {
  final BuildContext mainContext;

  const FilterDialog({Key key, this.mainContext}) : super(key: key);

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  BrowseFilterCubit _filterCubit;
  Function _unorderedEq = DeepCollectionEquality.unordered().equals;

  Map<String, FilterOrderBy> _sortMap = {
    'Recent': FilterOrderBy.recent,
    'Alpha asc': FilterOrderBy.alpha_asc,
    'Alpha desc': FilterOrderBy.alpha_desc,
    'Rating high': FilterOrderBy.rating_desc,
    'Rating low': FilterOrderBy.rating_asc,
  };

  Map<String, FilterType> _typeMap = {
    'All': FilterType.all,
    'Movie': FilterType.movie,
    'Series': FilterType.series,
  };

  FilterOrderBy _defaultSort;
  FilterType _defaultType;
  FilterOrderBy _selectedSort;
  FilterType _selectedType;
  List<String> _defaultGenres;
  List<String> _selectedGenres;

  @override
  void initState() {
    super.initState();

    print(_unorderedEq(['1', '2', '3'], []));

    _defaultSort = _sortMap['Recent'];
    _defaultType = _typeMap['All'];
    _defaultGenres = [];
    _filterCubit = context.bloc<BrowseFilterCubit>();

    // Restore selected values from the bloc state
    final _currentState = _filterCubit.state;
    if (_currentState is BrowseFilterModified) {
      _selectedSort = _currentState.filter.orderBy;
      _selectedType = _currentState.filter.type;
      _selectedGenres = _currentState.filter.genres == null ? null : []
        ..addAll(_currentState.filter.genres);
    }

    // If filter is not set in state, use default
    _selectedSort = _selectedSort ?? _defaultSort;
    _selectedType = _selectedType ?? _defaultType;
    _selectedGenres = _selectedGenres ?? []
      ..addAll(_defaultGenres);
  }

  // If filters are in default
  bool get isDefault =>
      _selectedSort == _defaultSort &&
      _selectedType == _defaultType &&
      _unorderedEq(_selectedGenres, _defaultGenres);

  @override
  Widget build(BuildContext context) {
    final _labelColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[400]
        : Colors.grey[600];
    final _labelStyle =
        Theme.of(context).textTheme.bodyText1.apply(color: _labelColor);

    return Container(
      margin:
          EdgeInsets.only(top: MediaQuery.of(widget.mainContext).padding.top),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Filter and Sort'),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SizedBox(height: 30),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Table(
                    columnWidths: {0: FixedColumnWidth(140.0)},
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        children: [
                          Text(
                            'SORT BY:',
                            style: _labelStyle,
                          ),
                          DropdownButtonFormField(
                            items: _sortMap.entries
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e.value,
                                    child: Text(e.key),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedSort = value;
                              });
                            },
                            value: _selectedSort,
                            isDense: false,
                            decoration:
                                InputDecoration.collapsed(hintText: null),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Text(
                            'TYPE:',
                            style: _labelStyle,
                          ),
                          DropdownButtonFormField(
                            items: _typeMap.entries
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e.value,
                                    child: Text(e.key),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedType = value;
                              });
                            },
                            value: _selectedType,
                            isDense: false,
                            decoration:
                                InputDecoration.collapsed(hintText: null),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'GENRES:',
                    style: _labelStyle,
                  ),
                  SizedBox(height: 12),
                  BlocBuilder<GenreListCubit, GenreListState>(
                    builder: (context, state) {
                      if (state is GenreListLoaded) {
                        return _buildGenreChipsWidget(state.genres);
                      }

                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        child: Wrap(
                          children: List.generate(
                            10,
                            (index) => Padding(
                              padding: const EdgeInsets.only(
                                  right: 8.0, bottom: 16.0),
                              child: Container(
                                width: 80,
                                height: 32,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Spacer(),
                  Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          RaisedButton(
                            onPressed: isDefault
                                ? null
                                : () {
                                    setState(() {
                                      _selectedSort = _defaultSort;
                                      _selectedType = _defaultType;
                                      _selectedGenres = []
                                        ..addAll(_defaultGenres);
                                    });
                                  },
                            child: Text('Reset'),
                          ),
                          RaisedButton(
                            onPressed: () {
                              if (isDefault) {
                                context.bloc<BrowseFilterCubit>().resetFilter();
                              } else {
                                context
                                    .bloc<BrowseFilterCubit>()
                                    .changeFilter(Filter(
                                      orderBy: _selectedSort,
                                      type: _selectedType,
                                      genres: []..addAll(_selectedGenres),
                                    ));
                              }
                              Navigator.pop(context);
                            },
                            child: Text('Apply'),
                            // color: Theme.of(context).primaryColor,
                            // textTheme: ButtonTextTheme.primary,
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenreChipsWidget(List<GetGenres$Query$Genre> genres) {
    List<Widget> _list = [];
    genres.forEach((genre) {
      _list.add(Padding(
        padding: const EdgeInsets.only(right: 8.0, bottom: 16.0),
        child: FilterChip(
          showCheckmark: false,
          selectedColor: Colors.blue[200],
          label: Text(genre.name.mn),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          selected: _selectedGenres.contains(genre.id),
          onSelected: (value) {
            setState(() {
              if (value) {
                _selectedGenres.add(genre.id);
              } else {
                _selectedGenres.removeWhere((String id) => id == genre.id);
              }
            });
          },
        ),
      ));
    });
    return Wrap(
      children: _list,
    );
  }
}
