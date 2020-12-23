import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_bar/sliver_button.dart';
import '../../../../core/widgets/material_dialog.dart';
import '../../../../locale/generated/l10n.dart';
import '../../genre/cubit/genre_list_cubit.dart';
import '../cubit/browse_filter_cubit.dart';
import 'filter_dialog.dart';

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
          icon: const Icon(Icons.tune),
          text: Text(
            TR.of(context).filter.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            final browseFilterCubit = context.read<BrowseFilterCubit>();
            final genreListCubit = context.read<GenreListCubit>();
            showCustomMaterialSheet(
              context: context,
              useRootNavigator: true,
              isDismissible: true,
              enableDrag: true,
              height: 1.0,
              labelBuilder: (context) => Text(TR.of(context).filter_and_sort),
              builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: browseFilterCubit),
                  BlocProvider.value(value: genreListCubit),
                ],
                child: const FilterDialog(),
              ),
            );
          },
        );
      },
    );
  }
}
