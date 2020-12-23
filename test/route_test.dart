import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kayaya_flutter/router.dart';
import 'package:mockito/mockito.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  group('Route parser', () {
    test('Series route should be correctly parsed from URI string', () {
      final seriesUri = Uri.parse('route://series?id=33');
      final routeSettings = MyRouter.parseRouteFromURI(seriesUri);
      expect(routeSettings.name, Routes.seriesPage);
      expect(routeSettings.arguments, isA<MediaArguments>());
      expect((routeSettings.arguments as MediaArguments).anime.id, '33');
    });
  });
}
