import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:kayaya_flutter/codegen/graphql_anilist_api.graphql.dart';
import 'package:kayaya_flutter/cubit/anime_details_cubit.dart';
import 'package:kayaya_flutter/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';

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
      BlocBuilder<AnimeDetailsCubit, AnimeDetailsState>(
        builder: (context, state) {
          if (state is AnimeDetailsError) {
            return Center(
              child: Text(state.exception.toString()),
            );
          }

          if (state is AnimeDetailsLoaded) {
            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
                child: Builder(
                  builder: (context) {
                    final items = <Widget>[];
                    items.addAll([
                      Text(
                        S.of(context).genre,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      SizedBox(height: 10),
                      Text(
                        (state.details.genres ?? [])
                            .map((e) => e.name)
                            .join(', '),
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ]);

                    items.addAll([
                      SizedBox(height: 30),
                      Text(
                        S.of(context).synopsis,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      SizedBox(height: 10),
                      HtmlWidget(
                        state.details.description,
                        textStyle: Theme.of(context).textTheme.caption,
                      ),
                    ]);

                    if (state.details.anilist.trailer?.site == 'youtube' &&
                        state.details.anilist.trailer?.thumbnail != null) {
                      items.addAll([
                        SizedBox(height: 30),
                        Text(
                          S.of(context).trailer,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        SizedBox(height: 10),
                        InkWell(
                          onTap: () async {
                            final url =
                                'https://youtube.com/watch?v=${state.details.anilist.trailer.id}';
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
                                  imageUrl:
                                      state.details.anilist.trailer.thumbnail,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                decoration: new BoxDecoration(
                                  color: Colors.black54, // border color
                                  border:
                                      Border.all(width: 1, color: Colors.white),
                                  shape: BoxShape.circle,
                                ),
                                width: 54.0,
                                height: 54.0,
                                child: Icon(
                                  Icons.play_arrow,
                                  size: 36.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]);
                    }

                    if (state.details.anilist.stats.scoreDistribution != null) {
                      items.addAll([
                        SizedBox(height: 30),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color:
                                  _isDark ? Colors.yellow : Colors.yellow[800],
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Score Distribution',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        _DistributionBarChart(
                          scoreDistribution:
                              state.details.anilist.stats.scoreDistribution,
                        ),
                      ]);
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: items,
                    );
                  },
                ),
              ),
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _DistributionBarChart extends StatelessWidget {
  final List<GraphqlAnilistApi$Query$Media$MediaStats$ScoreDistribution>
      scoreDistribution;

  const _DistributionBarChart({Key key, @required this.scoreDistribution})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final distributions = scoreDistribution.toList();
    // Fill missing items
    for (var i = 10; i <= 100; i += 10) {
      if (distributions.firstWhere((element) => element.score == i,
              orElse: () => null) ==
          null) {
        distributions.add(
          GraphqlAnilistApi$Query$Media$MediaStats$ScoreDistribution.fromJson({
            'amount': 0,
            'score': i,
          }),
        );
      }
    }
    distributions.sort((a, b) => a.score.compareTo(b.score));

    return Container(
      width: double.infinity,
      child: BarChart(
        BarChartData(
          barTouchData: BarTouchData(
            allowTouchBarBackDraw: true,
            touchTooltipData: BarTouchTooltipData(
              fitInsideHorizontally: true,
              tooltipBgColor: Colors.blueGrey,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final distribution = distributions[group.x];
                return BarTooltipItem(
                  distribution.amount.toString() +
                      '\n' +
                      (distribution.score / 10).toString(),
                  TextStyle(color: Colors.yellow),
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
                        .reduce((current, next) =>
                            current.amount > next.amount ? current : next)
                        .amount
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
