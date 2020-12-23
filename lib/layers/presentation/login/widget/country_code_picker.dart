import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../core/widgets/material_dialog.dart';
import '../model/country_code.dart';
import '../model/country_code_data.dart';

class CountryCodePicker extends StatefulWidget {
  final String defaultSelection;
  final List<String> favorites;
  final ValueChanged<String> onChanged;

  const CountryCodePicker({
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
    if (widget.favorites.isNotEmpty) {
      final _favs = codes
          .where(
            (e) => widget.favorites
                .map((e) => e.toLowerCase())
                .contains(e.countryCode),
          )
          .toList();
      for (final _fav in _favs.reversed) {
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
      onPressed: () async {
        final result = await showCustomMaterialSheet<CountryCode>(
          context: context,
          builder: (context) => CountryPickerDialog(codes: codes),
          labelBuilder: (_) => const Text('Country Picker'),
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
      child: Text(selectedCode.dialCodeFull),
    );
  }
}

class CountryPickerDialog extends StatefulWidget {
  final List<CountryCode> codes;

  const CountryPickerDialog({Key key, @required this.codes}) : super(key: key);

  @override
  _CountryPickerDialogState createState() => _CountryPickerDialogState();
}

class _CountryPickerDialogState extends State<CountryPickerDialog> {
  final List<CountryCode> _codesFiltered = [];

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
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search',
                isDense: true,
              ),
              style: const TextStyle(
                height: 1.3,
                fontSize: 18.0,
              ),
              onChanged: _filterResults,
            ),
          ),
          const Divider(height: 1.3, thickness: 1.3),
          Expanded(
            child: Material(
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
        ],
      ),
    );
  }

  void _filterResults(String query) {
    final _query = query.toLowerCase();
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
