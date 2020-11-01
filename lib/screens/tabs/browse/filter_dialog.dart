import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kayaya_flutter/api/graphql_api.graphql.dart';
import 'package:kayaya_flutter/cubit/browse_filter_cubit.dart';
import 'package:kayaya_flutter/cubit/genre_list_cubit.dart';
import 'package:kayaya_flutter/generated/l10n.dart';
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

  Map<FilterOrderBy, String> _sortMap = {
    FilterOrderBy.recent: S.current.filter_sort_recent,
    FilterOrderBy.alpha_asc: S.current.filter_sort_alpha_asc,
    FilterOrderBy.alpha_desc: S.current.filter_sort_alpha_desc,
    FilterOrderBy.rating_desc: S.current.filter_sort_rating_high,
    FilterOrderBy.rating_asc: S.current.filter_sort_rating_low,
  };

  Map<FilterType, String> _typeMap = {
    FilterType.all: S.current.all,
    FilterType.movie: S.current.movie,
    FilterType.series: S.current.series,
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

    _defaultSort = FilterOrderBy.recent;
    _defaultType = FilterType.all;
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

    context.bloc<GenreListCubit>().getGenreList();
  }

  // If filters are in default
  bool get isDefault =>
      _selectedSort == _defaultSort &&
      _selectedType == _defaultType &&
      _unorderedEq(_selectedGenres, _defaultGenres);

  @override
  Widget build(BuildContext context) {
    final bool _isDark = Theme.of(context).brightness == Brightness.dark;
    final _labelColor = _isDark ? Colors.grey[400] : Colors.grey[600];
    final _labelStyle =
        Theme.of(context).textTheme.bodyText1.apply(color: _labelColor);
    final _orientation = MediaQuery.of(context).orientation;

    return Container(
      margin:
          EdgeInsets.only(top: MediaQuery.of(widget.mainContext).padding.top),
      // color: Theme.of(context).scaffoldBackgroundColor,
      child: Scaffold(
        body: Builder(
          builder: (context) => Column(
            children: <Widget>[
              AppBar(
                primary: false,
                title: Text(S.of(context).filter_and_sort),
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Table(
                          columnWidths: {0: FixedColumnWidth(140.0)},
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: [
                            TableRow(
                              children: [
                                Text(
                                  '${S.of(context).sort.toUpperCase()}:',
                                  style: _labelStyle,
                                ),
                                DropdownButtonFormField(
                                  items: _sortMap.entries
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e.key,
                                          child: Text(e.value),
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
                                  '${S.of(context).type.toUpperCase()}:',
                                  style: _labelStyle,
                                ),
                                DropdownButtonFormField(
                                  items: _typeMap.entries
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e.key,
                                          child: Text(e.value),
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
                          '${S.of(context).genre.toUpperCase()}:',
                          style: _labelStyle,
                        ),
                        SizedBox(height: 12),
                        BlocBuilder<GenreListCubit, GenreListState>(
                          builder: (context, state) {
                            if (state is GenreListLoaded) {
                              return _buildGenreChipsWidget(state.genres);
                            }

                            return Shimmer.fromColors(
                              baseColor:
                                  _isDark ? Colors.grey[700] : Colors.grey[300],
                              highlightColor:
                                  _isDark ? Colors.grey[500] : Colors.grey[100],
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
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                child: Builder(
                  builder: (context) {
                    final resetButton = RaisedButton(
                      onPressed: isDefault
                          ? null
                          : () {
                              setState(() {
                                _selectedSort = _defaultSort;
                                _selectedType = _defaultType;
                                _selectedGenres = []..addAll(_defaultGenres);
                              });
                            },
                      child: Text(S.of(context).reset),
                      color: Colors.grey.shade300,
                      textTheme: ButtonTextTheme.primary,
                    );
                    final applyButton = RaisedButton(
                      onPressed: () {
                        if (isDefault) {
                          context.bloc<BrowseFilterCubit>().resetFilter();
                        } else {
                          context.bloc<BrowseFilterCubit>().changeFilter(Filter(
                                orderBy: _selectedSort,
                                type: _selectedType,
                                genres: []..addAll(_selectedGenres),
                              ));
                        }
                        Navigator.pop(context);
                      },
                      child: Text(S.of(context).apply),
                      // color: Theme.of(context).primaryColor,
                      // textTheme: ButtonTextTheme.primary,
                    );

                    if (_orientation == Orientation.landscape) {
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(child: resetButton),
                            SizedBox(width: 10),
                            Expanded(child: applyButton),
                          ]);
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        resetButton,
                        applyButton,
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenreChipsWidget(List<GetGenres$Query$Genres> genres) {
    final bool _isDark = Theme.of(context).brightness == Brightness.dark;

    List<Widget> _list = [];
    genres.forEach((genre) {
      _list.add(Padding(
        padding: const EdgeInsets.only(right: 8.0, bottom: 16.0),
        child: FilterChip(
          showCheckmark: false,
          backgroundColor: _isDark ? Colors.grey[800] : Colors.grey[200],
          selectedColor: _isDark ? Colors.blue[600] : Colors.blue[100],
          label: Text(genre.name),
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
