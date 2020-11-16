import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kayaya_flutter/routes.dart';
import 'package:kayaya_flutter/screens/series.dart';
import 'package:mockito/mockito.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  group('Route parser', () {
    test('Series route should be correctly parsed from URI string', () {
      var seriesUri = Uri.parse('route://series?id=33');
      var routeSettings = Routes.parseRouteFromUri(seriesUri);
      expect(routeSettings.name, 'series');
      expect(routeSettings.arguments, isA<MediaArguments>());
      expect((routeSettings.arguments as MediaArguments).anime.id, '33');
    });

    test('Parsed series route should resolve to correct MaterialPageRoute page',
        () {
      var seriesUri = Uri.parse('route://series?id=33');
      var route = Routes.fromURI(seriesUri);
      MockBuildContext _context = MockBuildContext();
      expect(route.builder.call(_context), isA<SeriesPage>());
    });
  });
}
