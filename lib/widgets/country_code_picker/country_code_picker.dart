import 'package:flutter/material.dart';
import 'package:kayaya_flutter/widgets/country_code_picker/country_code.dart';
import 'package:kayaya_flutter/widgets/country_code_picker/country_codes.dart';
import 'package:kayaya_flutter/widgets/material_dialog.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CountryCodePicker extends StatefulWidget {
  final String defaultSelection;
  final List<String> favorites;
  final ValueChanged<String> onChanged;

  CountryCodePicker({
    Key key,
    this.defaultSelection = 'MN',
    this.favorites = const [],
    this.onChanged,
  }) : super(key: key);

  @override
  _CountryCodePickerState createState() => _CountryCodePickerState();
}

class _CountryCodePickerState extends State<CountryCodePicker> {
  List<CountryCode> codes;
  CountryCode selectedCode;

  @override
  void initState() {
    super.initState();
    codes = countryCodes.map((e) => CountryCode.fromJson(e)).toList();
    // Show favorites first in list
    if (widget.favorites.length > 0) {
      var _favs = codes
          .where(
            (e) => widget.favorites
                .map((e) => e.toLowerCase())
                .contains(e.countryCode),
          )
          .toList();
      for (var _fav in _favs.reversed) {
        codes.remove(_fav);
        codes.insert(0, _fav);
      }
    }
    selectedCode = codes.firstWhere(
      (e) => e.countryCode == widget.defaultSelection,
      orElse: () => codes[0],
    );
  }

  @override
  void didUpdateWidget(covariant CountryCodePicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.defaultSelection != widget.defaultSelection) {
      selectedCode = codes.firstWhere(
        (e) => e.countryCode == widget.defaultSelection,
        orElse: () => codes[0],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: Text(selectedCode.dialCodeFull),
      onPressed: () async {
        final result = await showCustomMaterialSheet<CountryCode>(
          context: context,
          builder: (context) => CountryPickerDialog(codes: codes),
          label: 'Country Picker',
        );
        if (result != null) {
          setState(() {
            selectedCode = result;
          });
          if (widget.onChanged != null) {
            widget.onChanged(result.dialCodeFull);
          }
        }
      },
    );
  }
}

class GlowlessScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class CountryPickerDialog extends StatefulWidget {
  final List<CountryCode> codes;

  const CountryPickerDialog({Key key, @required this.codes}) : super(key: key);

  @override
  _CountryPickerDialogState createState() => _CountryPickerDialogState();
}

class _CountryPickerDialogState extends State<CountryPickerDialog> {
  List<CountryCode> _codesFiltered = [];

  @override
  void initState() {
    super.initState();
    _codesFiltered.addAll(widget.codes);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (_) {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search',
                isDense: true,
              ),
              style: TextStyle(
                height: 1.3,
                fontSize: 18.0,
              ),
              onChanged: _filterResults,
            ),
          ),
          Divider(height: 1.3, thickness: 1.3),
          Expanded(
            child: Material(
              child: ScrollConfiguration(
                behavior: GlowlessScrollBehavior(),
                child: ListView.builder(
                  controller: ModalScrollController.of(context),
                  padding: EdgeInsets.zero,
                  itemCount: _codesFiltered.length,
                  clipBehavior: Clip.antiAlias,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_codesFiltered[index].name),
                      trailing: Text(_codesFiltered[index].dialCodeFull),
                      onTap: () {
                        Navigator.pop(context, _codesFiltered[index]);
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _filterResults(String query) {
    String _query = query.toLowerCase();
    if (_query.isEmpty) {
      setState(() {
        _codesFiltered.clear();
        _codesFiltered.addAll(widget.codes);
      });
    } else {
      final _searchResult = widget.codes.where((e) =>
          e.name.toLowerCase().contains(_query) ||
          e.dialCodeFull.contains(_query));
      setState(() {
        _codesFiltered.clear();
        _codesFiltered.addAll(_searchResult);
      });
    }
  }
}
