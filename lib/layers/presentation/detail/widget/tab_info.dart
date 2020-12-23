import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../locale/generated/l10n.dart';
import '../../../domain/entities/detail.dart';
import '../cubit/details_cubit.dart';

class InfoTabViewItem extends StatefulWidget {
  final Key tabKey;

  const InfoTabViewItem({Key key, this.tabKey}) : super(key: key);

  @override
  _InfoTabViewItemState createState() => _InfoTabViewItemState();
}

class _InfoTabViewItemState extends State<InfoTabViewItem> {
  @override
  Widget build(BuildContext context) {
    final bool _isDark = Theme.of(context).brightness == Brightness.dark;

    return NestedScrollViewInnerScrollPositionKeyWidget(
      widget.tabKey,
      BlocBuilder<DetailsCubit, DetailsState>(
        builder: (context, state) {
          if (state is DetailsError) {
            return Center(
              child: Text(state.error),
            );
          }

          if (state is DetailsLoaded) {
            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
                child: Builder(
                  builder: (context) {
                    final items = <Widget>[];

                    if ((state.details.genres ?? []).isNotEmpty) {
                      items.addAll([
                        Text(
                          TR.of(context).genre,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          state.details.genres.map((e) => e.name).join(', '),
                          style: Theme.of(context).textTheme.caption,
                        ),
                        const SizedBox(height: 30),
                      ]);
                    }

                    if (state.details.description != null) {
                      items.addAll([
                        Text(
                          TR.of(context).synopsis,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        const SizedBox(height: 10),
                        HtmlWidget(
                          state.details.description,
                          textStyle: Theme.of(context).textTheme.caption,
                        ),
                        const SizedBox(height: 30),
                      ]);
                    }

                    if (state.details.trailer != null) {
                      items.addAll([
                        Text(
                          TR.of(context).trailer,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () async {
                            final url = state.details.trailer.url;
                            if (await canLaunch(url)) {
                              await launch(url);
                            }
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              AspectRatio(
                                aspectRatio: 16 / 9,
                                child: CachedNetworkImage(
                                  imageUrl: state.details.trailer.thumbnail,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black54, // border color
                                  border: Border.all(color: Colors.white),
                                  shape: BoxShape.circle,
                                ),
                                width: 54.0,
                                height: 54.0,
                                child: const Icon(
                                  Icons.play_arrow,
                                  size: 36.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                      ]);
                    }

                    if (state.details.scoreDistribution != null) {
                      items.addAll([
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: _isDark
                                  ? Colors.yellow
                                  : Colors.yellow.shade800,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Score Distribution',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        RepaintBoundary(
                          child: _DistributionBarChart(
                            scoreDistribution: state.details.scoreDistribution,
                          ),
                        ),
                      ]);
                    }

                    items.add(const SizedBox(height: 60));

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: items,
                    );
                  },
                ),
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _DistributionBarChart extends StatefulWidget {
  final List<ScoreDistribution> scoreDistribution;

  const _DistributionBarChart({Key key, @required this.scoreDistribution})
      : super(key: key);

  @override
  __DistributionBarChartState createState() => __DistributionBarChartState();
}

class __DistributionBarChartState extends State<_DistributionBarChart> {
  List<ScoreDistribution> distributions;

  @override
  void initState() {
    super.initState();
    distributions = List.of(widget.scoreDistribution);
    // Fill missing items
    for (var i = 10; i <= 100; i += 10) {
      if (distributions.firstWhere((element) => element.score == i,
              orElse: () => null) ==
          null) {
        distributions.add(
          ScoreDistribution(i, 0),
        );
      }
    }
    distributions.sort((a, b) => a.score.compareTo(b.score));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: BarChart(
        BarChartData(
          barTouchData: BarTouchData(
            allowTouchBarBackDraw: true,
            touchTooltipData: BarTouchTooltipData(
              fitInsideHorizontally: true,
              tooltipBottomMargin: 30.0,
              tooltipBgColor: Colors.blueGrey,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final distribution = distributions[group.x];
                return BarTooltipItem(
                  '${distribution.amount}\n${distribution.score / 10}',
                  const TextStyle(color: Colors.yellow),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (value) =>
                  Theme.of(context).textTheme.caption.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
              margin: 12,
              getTitles: (double value) {
                return (distributions[value.toInt()].score / 10).toString();
              },
            ),
            leftTitles: SideTitles(
              showTitles: false,
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          barGroups: List.generate(
            distributions.length,
            (index) => BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  y: max(
                    1,
                    distributions[index].amount.toDouble(),
                  ),
                  colors: [
                    Color.lerp(
                      Colors.redAccent.shade400,
                      Colors.greenAccent,
                      distributions[index].score / 100,
                    )
                  ],
                  width: 20,
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    y: distributions
                        .fold<int>(
                            0, (max, e) => e.amount > max ? e.amount : max)
                        .toDouble(),
                    // colors: [Colors.white],
                  ),
                ),
              ],
              showingTooltipIndicators: [],
            ),
          ),
        ),
      ),
    );
  }
}
