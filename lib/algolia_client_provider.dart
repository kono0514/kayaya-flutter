import 'package:algolia/algolia.dart';

class AlgoliaClientProvider {
  AlgoliaClientProvider._privateConstructor();

  static final AlgoliaClientProvider instance =
      AlgoliaClientProvider._privateConstructor();

  final Algolia algolia = Algolia.init(
      applicationId: 'IBF8ZIWBKS', apiKey: 'a248f7500d9424891a3892b7eadd25a7');
}
