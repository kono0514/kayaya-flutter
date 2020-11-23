import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kayaya_flutter/browse/browse.dart';
import 'package:kayaya_flutter/shared/cubit/genre_list_cubit.dart';
import 'package:kayaya_flutter/locale/generated/l10n.dart';
import 'package:kayaya_flutter/shared/widgets/app_bar/sliver_button.dart';

class FilterButton extends StatefulWidget {
  @override
  _FilterButtonState createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrowseFilterCubit, BrowseFilterState>(
      builder: (context, state) {
        final _hasFilter = state is BrowseFilterModified;

        return SliverButton(
          backgroundColor: _hasFilter ? Colors.blue : null,
          color: _hasFilter ? Colors.white : null,
          icon: Icon(Icons.tune),
          text: Text(
            TR.of(context).filter.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            BuildContext mainContext = context;
            final browseFilterCubit = context.read<BrowseFilterCubit>();
            final genreListCubit = context.read<GenreListCubit>();
            showModalBottomSheet(
              context: context,
              useRootNavigator: true,
              isScrollControlled: true,
              isDismissible: false,
              enableDrag: true,
              backgroundColor: Colors.transparent,
              builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: browseFilterCubit),
                  BlocProvider.value(value: genreListCubit),
                ],
                child: FilterDialog(
                  mainContext: mainContext,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
