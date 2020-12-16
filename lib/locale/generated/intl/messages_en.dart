// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static m0(count) => "${count} eps";

  static m1(runtime) => "${runtime} min";

  static m2(number) => "Episode ${number}";

  static m3(digit, number) => "Enter the ${digit}-digit code that was sent to ${number} via SMS";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "about" : MessageLookupByLibrary.simpleMessage("About"),
    "all" : MessageLookupByLibrary.simpleMessage("All"),
    "apply" : MessageLookupByLibrary.simpleMessage("Apply"),
    "check_for_update" : MessageLookupByLibrary.simpleMessage("Check for Update"),
    "clear_search_history" : MessageLookupByLibrary.simpleMessage("Clear search history"),
    "clear_search_history_success" : MessageLookupByLibrary.simpleMessage("Search history cleared."),
    "credits" : MessageLookupByLibrary.simpleMessage("Credits"),
    "detail_episode_count" : m0,
    "detail_runtime" : m1,
    "developer" : MessageLookupByLibrary.simpleMessage("Developer"),
    "do_search" : MessageLookupByLibrary.simpleMessage("Search"),
    "episode_item" : m2,
    "episodes" : MessageLookupByLibrary.simpleMessage("Episodes"),
    "error_fetch" : MessageLookupByLibrary.simpleMessage("Failed to fetch"),
    "filter" : MessageLookupByLibrary.simpleMessage("Filter"),
    "filter_and_sort" : MessageLookupByLibrary.simpleMessage("Filter and Sort"),
    "filter_sort_alpha_asc" : MessageLookupByLibrary.simpleMessage("Alphabetically (A-Z)"),
    "filter_sort_alpha_desc" : MessageLookupByLibrary.simpleMessage("Alphabetically (Z-A)"),
    "filter_sort_rating_high" : MessageLookupByLibrary.simpleMessage("High Rating"),
    "filter_sort_rating_low" : MessageLookupByLibrary.simpleMessage("Low Rating"),
    "filter_sort_recent" : MessageLookupByLibrary.simpleMessage("Most Recent"),
    "general" : MessageLookupByLibrary.simpleMessage("General"),
    "genre" : MessageLookupByLibrary.simpleMessage("Genre"),
    "info" : MessageLookupByLibrary.simpleMessage("Info"),
    "language" : MessageLookupByLibrary.simpleMessage("Language"),
    "language_updated" : MessageLookupByLibrary.simpleMessage("Language updated. Restart the app to see the changes."),
    "movie" : MessageLookupByLibrary.simpleMessage("Movie"),
    "newly_added" : MessageLookupByLibrary.simpleMessage("Newly Added"),
    "no_episodes" : MessageLookupByLibrary.simpleMessage("No episodes found"),
    "no_subscriptions" : MessageLookupByLibrary.simpleMessage("No active subscription found. Subscribe to a series to receive notification when a new episode gets added."),
    "phone_auth_change_number" : MessageLookupByLibrary.simpleMessage("Change number"),
    "phone_auth_header_text" : MessageLookupByLibrary.simpleMessage("Sign in using your phone number"),
    "phone_auth_send_sms" : MessageLookupByLibrary.simpleMessage("Send SMS code"),
    "phone_auth_sent_success" : m3,
    "phone_auth_verify" : MessageLookupByLibrary.simpleMessage("Verify"),
    "phone_auth_verify_header_text" : MessageLookupByLibrary.simpleMessage("Verify SMS code"),
    "play" : MessageLookupByLibrary.simpleMessage("Play"),
    "recommended" : MessageLookupByLibrary.simpleMessage("Recommended"),
    "related" : MessageLookupByLibrary.simpleMessage("Related"),
    "reserved_word_return" : MessageLookupByLibrary.simpleMessage("Return"),
    "reset" : MessageLookupByLibrary.simpleMessage("Reset"),
    "search" : MessageLookupByLibrary.simpleMessage("Search"),
    "series" : MessageLookupByLibrary.simpleMessage("Series"),
    "settings" : MessageLookupByLibrary.simpleMessage("Settings"),
    "share" : MessageLookupByLibrary.simpleMessage("Share"),
    "sign_in_anonymous" : MessageLookupByLibrary.simpleMessage("Continue without signing in"),
    "sign_in_facebook" : MessageLookupByLibrary.simpleMessage("Sign in with Facebook"),
    "sign_in_google" : MessageLookupByLibrary.simpleMessage("Sign in with Google"),
    "sign_in_number" : MessageLookupByLibrary.simpleMessage("Sign in with Phone"),
    "signout" : MessageLookupByLibrary.simpleMessage("Signout"),
    "sort" : MessageLookupByLibrary.simpleMessage("Sort by"),
    "sort_asc" : MessageLookupByLibrary.simpleMessage("Asc"),
    "sort_desc" : MessageLookupByLibrary.simpleMessage("Desc"),
    "source_chooser_title" : MessageLookupByLibrary.simpleMessage("Choose source"),
    "source_code" : MessageLookupByLibrary.simpleMessage("Source code"),
    "subscribe" : MessageLookupByLibrary.simpleMessage("Subscribe"),
    "subscribe_success" : MessageLookupByLibrary.simpleMessage("Subscribed. You\'ll get notified when a new episode is added."),
    "subscriptions" : MessageLookupByLibrary.simpleMessage("Subscriptions"),
    "synopsis" : MessageLookupByLibrary.simpleMessage("Synopsis"),
    "tabs_browse" : MessageLookupByLibrary.simpleMessage("Browse"),
    "tabs_discover" : MessageLookupByLibrary.simpleMessage("Discover"),
    "tabs_library" : MessageLookupByLibrary.simpleMessage("Library"),
    "tabs_search" : MessageLookupByLibrary.simpleMessage("Search"),
    "theme" : MessageLookupByLibrary.simpleMessage("Theme"),
    "theme_dark" : MessageLookupByLibrary.simpleMessage("Dark"),
    "theme_light" : MessageLookupByLibrary.simpleMessage("Light"),
    "theme_system" : MessageLookupByLibrary.simpleMessage("System"),
    "top_movies" : MessageLookupByLibrary.simpleMessage("Top Movies"),
    "top_series" : MessageLookupByLibrary.simpleMessage("Top Series"),
    "trailer" : MessageLookupByLibrary.simpleMessage("Trailer"),
    "trending" : MessageLookupByLibrary.simpleMessage("Trending"),
    "type" : MessageLookupByLibrary.simpleMessage("Type"),
    "unsubscribe" : MessageLookupByLibrary.simpleMessage("Unsubscribe"),
    "unsubscribe_success" : MessageLookupByLibrary.simpleMessage("Unsubscribed.")
  };
}
