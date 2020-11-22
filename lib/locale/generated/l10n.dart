// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class TR {
  TR();
  
  static TR current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<TR> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      TR.current = TR();
      
      return TR.current;
    });
  } 

  static TR of(BuildContext context) {
    return Localizations.of<TR>(context, TR);
  }

  /// `About`
  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message(
      'Apply',
      name: 'apply',
      desc: '',
      args: [],
    );
  }

  /// `Clear search history`
  String get clear_search_history {
    return Intl.message(
      'Clear search history',
      name: 'clear_search_history',
      desc: '',
      args: [],
    );
  }

  /// `Search history cleared.`
  String get clear_search_history_success {
    return Intl.message(
      'Search history cleared.',
      name: 'clear_search_history_success',
      desc: '',
      args: [],
    );
  }

  /// `Credits`
  String get credits {
    return Intl.message(
      'Credits',
      name: 'credits',
      desc: '',
      args: [],
    );
  }

  /// `{count} eps`
  String detail_episode_count(Object count) {
    return Intl.message(
      '$count eps',
      name: 'detail_episode_count',
      desc: '',
      args: [count],
    );
  }

  /// `{runtime} min`
  String detail_runtime(Object runtime) {
    return Intl.message(
      '$runtime min',
      name: 'detail_runtime',
      desc: '',
      args: [runtime],
    );
  }

  /// `Developer`
  String get developer {
    return Intl.message(
      'Developer',
      name: 'developer',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get do_search {
    return Intl.message(
      'Search',
      name: 'do_search',
      desc: '',
      args: [],
    );
  }

  /// `Episode {number}`
  String episode_item(Object number) {
    return Intl.message(
      'Episode $number',
      name: 'episode_item',
      desc: '',
      args: [number],
    );
  }

  /// `Episodes`
  String get episodes {
    return Intl.message(
      'Episodes',
      name: 'episodes',
      desc: '',
      args: [],
    );
  }

  /// `Failed to fetch`
  String get error_fetch {
    return Intl.message(
      'Failed to fetch',
      name: 'error_fetch',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filter {
    return Intl.message(
      'Filter',
      name: 'filter',
      desc: '',
      args: [],
    );
  }

  /// `Filter and Sort`
  String get filter_and_sort {
    return Intl.message(
      'Filter and Sort',
      name: 'filter_and_sort',
      desc: '',
      args: [],
    );
  }

  /// `Alphabetically (A-Z)`
  String get filter_sort_alpha_asc {
    return Intl.message(
      'Alphabetically (A-Z)',
      name: 'filter_sort_alpha_asc',
      desc: '',
      args: [],
    );
  }

  /// `Alphabetically (Z-A)`
  String get filter_sort_alpha_desc {
    return Intl.message(
      'Alphabetically (Z-A)',
      name: 'filter_sort_alpha_desc',
      desc: '',
      args: [],
    );
  }

  /// `High Rating`
  String get filter_sort_rating_high {
    return Intl.message(
      'High Rating',
      name: 'filter_sort_rating_high',
      desc: '',
      args: [],
    );
  }

  /// `Low Rating`
  String get filter_sort_rating_low {
    return Intl.message(
      'Low Rating',
      name: 'filter_sort_rating_low',
      desc: '',
      args: [],
    );
  }

  /// `Most Recent`
  String get filter_sort_recent {
    return Intl.message(
      'Most Recent',
      name: 'filter_sort_recent',
      desc: '',
      args: [],
    );
  }

  /// `General`
  String get general {
    return Intl.message(
      'General',
      name: 'general',
      desc: '',
      args: [],
    );
  }

  /// `Genre`
  String get genre {
    return Intl.message(
      'Genre',
      name: 'genre',
      desc: '',
      args: [],
    );
  }

  /// `Info`
  String get info {
    return Intl.message(
      'Info',
      name: 'info',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Language updated. Restart the app to see the changes.`
  String get language_updated {
    return Intl.message(
      'Language updated. Restart the app to see the changes.',
      name: 'language_updated',
      desc: '',
      args: [],
    );
  }

  /// `Movie`
  String get movie {
    return Intl.message(
      'Movie',
      name: 'movie',
      desc: '',
      args: [],
    );
  }

  /// `Newly Added`
  String get newly_added {
    return Intl.message(
      'Newly Added',
      name: 'newly_added',
      desc: '',
      args: [],
    );
  }

  /// `No episodes found`
  String get no_episodes {
    return Intl.message(
      'No episodes found',
      name: 'no_episodes',
      desc: '',
      args: [],
    );
  }

  /// `No active subscription found. Subscribe to a series to receive notification when a new episode gets added.`
  String get no_subscriptions {
    return Intl.message(
      'No active subscription found. Subscribe to a series to receive notification when a new episode gets added.',
      name: 'no_subscriptions',
      desc: '',
      args: [],
    );
  }

  /// `Play`
  String get play {
    return Intl.message(
      'Play',
      name: 'play',
      desc: '',
      args: [],
    );
  }

  /// `Recommended`
  String get recommended {
    return Intl.message(
      'Recommended',
      name: 'recommended',
      desc: '',
      args: [],
    );
  }

  /// `Related`
  String get related {
    return Intl.message(
      'Related',
      name: 'related',
      desc: '',
      args: [],
    );
  }

  /// `Return`
  String get reserved_word_return {
    return Intl.message(
      'Return',
      name: 'reserved_word_return',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get reset {
    return Intl.message(
      'Reset',
      name: 'reset',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Series`
  String get series {
    return Intl.message(
      'Series',
      name: 'series',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Sort by`
  String get sort {
    return Intl.message(
      'Sort by',
      name: 'sort',
      desc: '',
      args: [],
    );
  }

  /// `Asc`
  String get sort_asc {
    return Intl.message(
      'Asc',
      name: 'sort_asc',
      desc: '',
      args: [],
    );
  }

  /// `Desc`
  String get sort_desc {
    return Intl.message(
      'Desc',
      name: 'sort_desc',
      desc: '',
      args: [],
    );
  }

  /// `Choose source`
  String get source_chooser_title {
    return Intl.message(
      'Choose source',
      name: 'source_chooser_title',
      desc: '',
      args: [],
    );
  }

  /// `Source code`
  String get source_code {
    return Intl.message(
      'Source code',
      name: 'source_code',
      desc: '',
      args: [],
    );
  }

  /// `Subscribe`
  String get subscribe {
    return Intl.message(
      'Subscribe',
      name: 'subscribe',
      desc: '',
      args: [],
    );
  }

  /// `Subscribed. You'll receive a notification when new episode gets added.`
  String get subscribe_success {
    return Intl.message(
      'Subscribed. You\'ll receive a notification when new episode gets added.',
      name: 'subscribe_success',
      desc: '',
      args: [],
    );
  }

  /// `Subscriptions`
  String get subscriptions {
    return Intl.message(
      'Subscriptions',
      name: 'subscriptions',
      desc: '',
      args: [],
    );
  }

  /// `Synopsis`
  String get synopsis {
    return Intl.message(
      'Synopsis',
      name: 'synopsis',
      desc: '',
      args: [],
    );
  }

  /// `Browse`
  String get tabs_browse {
    return Intl.message(
      'Browse',
      name: 'tabs_browse',
      desc: '',
      args: [],
    );
  }

  /// `Discover`
  String get tabs_discover {
    return Intl.message(
      'Discover',
      name: 'tabs_discover',
      desc: '',
      args: [],
    );
  }

  /// `Library`
  String get tabs_library {
    return Intl.message(
      'Library',
      name: 'tabs_library',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get tabs_search {
    return Intl.message(
      'Search',
      name: 'tabs_search',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message(
      'Theme',
      name: 'theme',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get theme_dark {
    return Intl.message(
      'Dark',
      name: 'theme_dark',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get theme_light {
    return Intl.message(
      'Light',
      name: 'theme_light',
      desc: '',
      args: [],
    );
  }

  /// `System`
  String get theme_system {
    return Intl.message(
      'System',
      name: 'theme_system',
      desc: '',
      args: [],
    );
  }

  /// `Top Movies`
  String get top_movies {
    return Intl.message(
      'Top Movies',
      name: 'top_movies',
      desc: '',
      args: [],
    );
  }

  /// `Top Series`
  String get top_series {
    return Intl.message(
      'Top Series',
      name: 'top_series',
      desc: '',
      args: [],
    );
  }

  /// `Trailer`
  String get trailer {
    return Intl.message(
      'Trailer',
      name: 'trailer',
      desc: '',
      args: [],
    );
  }

  /// `Trending`
  String get trending {
    return Intl.message(
      'Trending',
      name: 'trending',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get type {
    return Intl.message(
      'Type',
      name: 'type',
      desc: '',
      args: [],
    );
  }

  /// `Unsubscribe`
  String get unsubscribe {
    return Intl.message(
      'Unsubscribe',
      name: 'unsubscribe',
      desc: '',
      args: [],
    );
  }

  /// `Unsubscribed.`
  String get unsubscribe_success {
    return Intl.message(
      'Unsubscribed.',
      name: 'unsubscribe_success',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<TR> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'mn'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<TR> load(Locale locale) => TR.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}