// ignore_for_file: avoid_print
import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Warmup test', () {
    FlutterDriver driver;

    setUpAll(() async {
      // Connect to a running Flutter application instance.
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) driver.close();
    });

    test('Test all', () async {
      final timeline = await driver.traceAction(
        () async {
          await runWarmup(driver);
        },
        streams: const <TimelineStream>[
          TimelineStream.dart,
          TimelineStream.embedder,
        ],
      );

      final summary = TimelineSummary.summarize(timeline);
      await summary.writeSummaryToFile('transitions', pretty: true);
      await summary.writeTimelineToFile('transitions', pretty: true);
    });
  });
}

Future<void> runWarmup(FlutterDriver driver) async {
  print('> Login page');
  final loginPhone = find.text('Sign in with Phone');
  await driver.tap(loginPhone);
  // Show country picker bottom modal sheet
  final countryPickerBtn = find.text('+976');
  final countryPickerDialog = find.byType('CountryCodePicker');
  await driver.tap(countryPickerBtn);
  // Close country picker bottom modal sheet
  await driver.scroll(
    countryPickerDialog,
    0,
    600,
    const Duration(milliseconds: 300),
  );
  await driver.tap(find.pageBack());

  await driver.tap(find.text('TEST USER'));

  sleep(const Duration(milliseconds: 500));

  print('> Featured page');
  final navBar = find.byValueKey('BottomNavigationBar');
  await driver.waitFor(navBar);

  final featuredTabItem = find.descendant(
    of: find.byType('BottomNavigationBar'),
    matching: find.text('Discover'),
    firstMatchOnly: true,
  );
  await driver.tap(featuredTabItem);

  final dynamicBuild = find.byValueKey('FeaturedPageRefreshIndicator');
  await driver.waitFor(dynamicBuild);

  sleep(const Duration(milliseconds: 500));

  print('> Browse page');
  final browseTabItem = find.descendant(
    of: find.byType('BottomNavigationBar'),
    matching: find.text('Browse'),
    firstMatchOnly: true,
  );
  await driver.tap(browseTabItem);

  // Wait for the populated list to show up
  final browseList = find.byValueKey('BrowseSliverList');
  await driver.waitFor(browseList);
  // Scroll the list so the appbar title and button in/out animation plays
  final browseScrollView = find.byValueKey('BrowseScrollView');
  await driver.scroll(
    browseScrollView,
    0,
    -200,
    const Duration(milliseconds: 300),
  );
  await driver.scroll(
    browseScrollView,
    0,
    200,
    const Duration(milliseconds: 300),
  );
  // Click on the first item
  final firstItem = find.descendant(
    of: find.byValueKey('BrowseSliverList'),
    matching: find.byType('BrowseListItem'),
    firstMatchOnly: true,
  );
  await driver.tap(firstItem);
  // Click Episodes tab (If series)
  final episodesTab = find.descendant(
    of: find.byType('TabBar'),
    matching: find.text('EPISODES'),
    firstMatchOnly: true,
  );
  bool episodesTapped = false;
  try {
    await driver.tap(episodesTab);
    episodesTapped = true;
  } catch (e) {
    //
  }
  if (episodesTapped) {
    await driver.waitFor(find.byValueKey('EpisodesSliverList'));
  }
  // Click Related tab
  final relatedTab = find.descendant(
    of: find.byType('TabBar'),
    matching: find.text('RELATED'),
    firstMatchOnly: true,
  );
  await driver.tap(relatedTab);
  sleep(const Duration(seconds: 1));
  await driver.tap(find.pageBack());

  // Show filter bottom modal sheet
  final filterButton = find.byValueKey('FilterButton');
  await driver.tap(filterButton);
  final filterDialog = find.byValueKey('FilterDialog');
  await driver.waitFor(filterDialog);
  // Open filter sort dropdown
  await driver.tap(find.byValueKey('FilterSortDropdownButton'));
  // Close filter sort dropdown
  await driver.tap(find.text('Most Recent'));
  sleep(const Duration(milliseconds: 500));
  // Close filter bottom modal sheet
  await driver.scroll(
    filterDialog,
    0,
    600,
    const Duration(milliseconds: 300),
  );

  print('> Library page');
  final libraryTabItem = find.descendant(
    of: find.byType('BottomNavigationBar'),
    matching: find.text('Library'),
    firstMatchOnly: true,
  );
  await driver.tap(libraryTabItem);

  // Show settings bottom modal sheet
  final settingsButton = find.byValueKey('SettingsButton');
  await driver.tap(settingsButton);
  final settingsDialog = find.byValueKey('SettingsDialog');
  await driver.waitFor(settingsDialog);
  // Open language chooser dialog
  final languageChooser = find.text('Language');
  await driver.tap(languageChooser);
  // Close language chooser dialog
  await driver.tap(find.text('English'));
  sleep(const Duration(milliseconds: 500));
  // Close settings bottom modal sheet
  await driver.scroll(
    settingsDialog,
    0,
    600,
    const Duration(milliseconds: 300),
  );

  print('> Search page');
  final searchTabItem = find.descendant(
    of: find.byType('BottomNavigationBar'),
    matching: find.text('Search'),
    firstMatchOnly: true,
  );
  await driver.tap(searchTabItem);
  sleep(const Duration(milliseconds: 500));
  await driver.tap(find.pageBack());
}
