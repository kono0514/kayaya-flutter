import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/widgets/app_bar/custom_sliver_app_bar.dart';
import '../../../../core/widgets/dynamic_widget_parser/auto_size_text_parser.dart';
import '../../../../core/widgets/dynamic_widget_parser/carousel_slider_item_child_faded.dart';
import '../../../../core/widgets/dynamic_widget_parser/carousel_slider_parser.dart';
import '../../../../core/widgets/dynamic_widget_parser/childless_sized_box_parser.dart';
import '../../../../core/widgets/dynamic_widget_parser/custom_listview_parser.dart';
import '../../../../core/widgets/dynamic_widget_parser/rounded_cached_network_image_parser.dart';
import '../../../../core/widgets/dynamic_widget_parser/scale_down_on_tap_parser.dart';
import '../../../../locale/generated/l10n.dart';
import '../../../../router.dart';
import '../cubit/featured_cubit.dart';

class FeaturedPage extends StatefulWidget {
  final ScrollController scrollController;

  const FeaturedPage({Key key, this.scrollController}) : super(key: key);

  @override
  _FeaturedPageState createState() => _FeaturedPageState();
}

class _FeaturedPageState extends State<FeaturedPage> {
  @override
  void initState() {
    super.initState();
    DynamicWidgetBuilder.addParser(AutoSizeTextWidgetParser());
    DynamicWidgetBuilder.addParser(ChildlessSizedBoxWidgetParser());
    DynamicWidgetBuilder.addParser(RoundedCachedNetworkImageWidgetParser());
    DynamicWidgetBuilder.addParser(CustomListViewWidgetParser());
    DynamicWidgetBuilder.addParser(CarouselSliderWidgetParser());
    DynamicWidgetBuilder.addParser(CarouselSliderItemFadedChildWidgetParser());
    DynamicWidgetBuilder.addParser(ScaleDownOnTapWidgetParser());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<FeaturedCubit>()..fetch(),
      child: Scaffold(
        extendBody: true,
        body: NestedScrollView(
          controller: widget.scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              CustomSliverAppBar(
                title: Text(TR.of(context).tabs_discover),
              ),
            ];
          },
          body: BlocBuilder<FeaturedCubit, FeaturedState>(
            builder: (context, state) {
              if (state is FeaturedError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                      TextButton(
                        onPressed: () async =>
                            context.read<FeaturedCubit>().fetch(),
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state is FeaturedLoaded) {
                return RefreshIndicator(
                  onRefresh: () async => context.read<FeaturedCubit>().fetch(),
                  child: DynamicWidgetBuilder.build(
                    state.data,
                    context,
                    new DefaultClickListener(context: context),
                  ),
                );
              }

              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}

class DefaultClickListener implements ClickListener {
  BuildContext context;

  DefaultClickListener({@required this.context});

  @override
  void onClicked(String event) {
    print("Receive click event: " + event);
    if (event.trim().isEmpty) return;

    final uri = Uri.parse(event.trim());
    final route = MyRouter.fromURI(uri);

    if (route != null) {
      Navigator.of(
        context,
        rootNavigator: true,
      ).push(route);
    }
  }
}
