// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a mn locale. All the
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
  String get localeName => 'mn';

  static m0(count) => "${count} анги";

  static m1(runtime) => "${runtime} мин";

  static m2(number) => "${number}-р анги";

  static m3(digit, number) => "${number} дугаарт явуулсан ${digit} оронтой кодыг оруулна уу";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "about" : MessageLookupByLibrary.simpleMessage("Тухай"),
    "all" : MessageLookupByLibrary.simpleMessage("Бүгд"),
    "apply" : MessageLookupByLibrary.simpleMessage("Apply"),
    "check_for_update" : MessageLookupByLibrary.simpleMessage("Шинэчлэх"),
    "clear_search_history" : MessageLookupByLibrary.simpleMessage("Хайлтын түүх устгах"),
    "clear_search_history_success" : MessageLookupByLibrary.simpleMessage("Амжилттай устгагдлаа."),
    "credits" : MessageLookupByLibrary.simpleMessage("Credits"),
    "detail_episode_count" : m0,
    "detail_runtime" : m1,
    "developer" : MessageLookupByLibrary.simpleMessage("Хөгжүүлэгч"),
    "do_search" : MessageLookupByLibrary.simpleMessage("Хайх"),
    "episode_item" : m2,
    "episodes" : MessageLookupByLibrary.simpleMessage("Ангиуд"),
    "error_fetch" : MessageLookupByLibrary.simpleMessage("Өгөгдөл дамжуулах алдаа"),
    "filter" : MessageLookupByLibrary.simpleMessage("Шүүх"),
    "filter_and_sort" : MessageLookupByLibrary.simpleMessage("Шүүх & Эрэмбэлэх"),
    "filter_sort_alpha_asc" : MessageLookupByLibrary.simpleMessage("Нэрээр (А-Я)"),
    "filter_sort_alpha_desc" : MessageLookupByLibrary.simpleMessage("Нэрээр (Я-А)"),
    "filter_sort_rating_high" : MessageLookupByLibrary.simpleMessage("Үнэлгээ өндөр"),
    "filter_sort_rating_low" : MessageLookupByLibrary.simpleMessage("Үнэлгээ бага"),
    "filter_sort_recent" : MessageLookupByLibrary.simpleMessage("Шинэ"),
    "general" : MessageLookupByLibrary.simpleMessage("Үндсэн"),
    "genre" : MessageLookupByLibrary.simpleMessage("Жанр"),
    "info" : MessageLookupByLibrary.simpleMessage("Мэдээлэл"),
    "language" : MessageLookupByLibrary.simpleMessage("Хэл"),
    "language_updated" : MessageLookupByLibrary.simpleMessage("Хэл солигдлоо. Апп-ыг гаргаад оруулахад өөрчлөлт бүрэн орно."),
    "movie" : MessageLookupByLibrary.simpleMessage("Кино"),
    "newly_added" : MessageLookupByLibrary.simpleMessage("Шинээр нэмэгдсэн"),
    "no_episodes" : MessageLookupByLibrary.simpleMessage("Одоогоор анги нэмэгдээгүй байна"),
    "no_subscriptions" : MessageLookupByLibrary.simpleMessage("Цувралуудад subscribe хийснээр шинэ анги нэмэгдэхэд сонордуулга авах боломжтой."),
    "phone_auth_change_number" : MessageLookupByLibrary.simpleMessage("Өөр дугаар"),
    "phone_auth_header_text" : MessageLookupByLibrary.simpleMessage("Утасны дугаараа ашиглан нэврэх"),
    "phone_auth_send_sms" : MessageLookupByLibrary.simpleMessage("Мэссэж илгээ"),
    "phone_auth_sent_success" : m3,
    "phone_auth_verify" : MessageLookupByLibrary.simpleMessage("Баталгаажуулах"),
    "phone_auth_verify_header_text" : MessageLookupByLibrary.simpleMessage("Код баталгаажуулах"),
    "play" : MessageLookupByLibrary.simpleMessage("Тоглуулах"),
    "recommended" : MessageLookupByLibrary.simpleMessage("Санал болгох"),
    "related" : MessageLookupByLibrary.simpleMessage("Ижил төстэй"),
    "reserved_word_return" : MessageLookupByLibrary.simpleMessage("Буцах"),
    "reset" : MessageLookupByLibrary.simpleMessage("Reset"),
    "search" : MessageLookupByLibrary.simpleMessage("Хайлт"),
    "series" : MessageLookupByLibrary.simpleMessage("Цуврал"),
    "settings" : MessageLookupByLibrary.simpleMessage("Тохиргоо"),
    "share" : MessageLookupByLibrary.simpleMessage("Хуваалцах"),
    "sign_in_anonymous" : MessageLookupByLibrary.simpleMessage("Дараад нь нээе"),
    "sign_in_facebook" : MessageLookupByLibrary.simpleMessage("Facebook-ээр нэвтрэх"),
    "sign_in_google" : MessageLookupByLibrary.simpleMessage("Google-ээр нэвтрэх"),
    "sign_in_number" : MessageLookupByLibrary.simpleMessage("Дугаараар нэвтрэх"),
    "signout" : MessageLookupByLibrary.simpleMessage("Гарах"),
    "sort" : MessageLookupByLibrary.simpleMessage("Эрэмбэлэх"),
    "sort_asc" : MessageLookupByLibrary.simpleMessage("Өсөх"),
    "sort_desc" : MessageLookupByLibrary.simpleMessage("Буурах"),
    "source_chooser_title" : MessageLookupByLibrary.simpleMessage("Гаргалт сонгох"),
    "source_code" : MessageLookupByLibrary.simpleMessage("Эх код"),
    "subscribe" : MessageLookupByLibrary.simpleMessage("Subscribe"),
    "subscribe_success" : MessageLookupByLibrary.simpleMessage("Subcribed. Шинэ анги нэмэгдэхэд сонордуулга очих болно."),
    "subscriptions" : MessageLookupByLibrary.simpleMessage("Subscriptions"),
    "synopsis" : MessageLookupByLibrary.simpleMessage("Агуулга"),
    "tabs_browse" : MessageLookupByLibrary.simpleMessage("Анийм"),
    "tabs_discover" : MessageLookupByLibrary.simpleMessage("Онцлох"),
    "tabs_library" : MessageLookupByLibrary.simpleMessage("Миний сан"),
    "tabs_search" : MessageLookupByLibrary.simpleMessage("Хайлт"),
    "theme" : MessageLookupByLibrary.simpleMessage("Theme"),
    "theme_dark" : MessageLookupByLibrary.simpleMessage("Dark"),
    "theme_light" : MessageLookupByLibrary.simpleMessage("Light"),
    "theme_system" : MessageLookupByLibrary.simpleMessage("System"),
    "top_movies" : MessageLookupByLibrary.simpleMessage("Шилдэг кино"),
    "top_series" : MessageLookupByLibrary.simpleMessage("Шилдэг цуврал"),
    "trailer" : MessageLookupByLibrary.simpleMessage("Трэйлэр"),
    "trending" : MessageLookupByLibrary.simpleMessage("Trending"),
    "type" : MessageLookupByLibrary.simpleMessage("Төрөл"),
    "unsubscribe" : MessageLookupByLibrary.simpleMessage("Unsubscribe"),
    "unsubscribe_success" : MessageLookupByLibrary.simpleMessage("Unsubscribed.")
  };
}
