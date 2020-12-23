import 'dart:async';

import 'package:graphql/client.dart';
import 'package:meta/meta.dart';

import '../../layers/domain/usecases/authentication/get_id_token_usecase.dart';
import '../usecase.dart';

GraphQLClient getGraphQLClient({
  @required String Function() getLocale,
  @required GetIdTokenUsecase getIdTokenUsecase,
}) {
  final GraphQLCache cache = GraphQLCache();

  final httpLink = HttpLink(
    // 'https://api.kayaya.stream/graphql',
    'http://aniim-api.test/graphql',
  );
  final authLink = AuthLink(
    getToken: () async {
      final _result = await getIdTokenUsecase(NoParams());
      String token;
      _result.fold((l) => token = '', (r) => token = r);
      return 'Bearer $token';
    },
  );
  final localeLink = LocaleLink(getLocale: getLocale);
  final links = Link.from([
    localeLink,
    authLink,
    httpLink,
  ]);

  return GraphQLClient(
    link: links,
    cache: cache,
  );
}

class LocaleLink extends Link {
  final String Function() getLocale;
  LocaleLink({@required this.getLocale});

  @override
  Stream<Response> request(Request request, [forward]) {
    final locale = getLocale();
    final req = request.updateContextEntry<HttpLinkHeaders>(
      (headers) => HttpLinkHeaders(
        headers: <String, String>{
          ...headers?.headers ?? <String, String>{},
          'Accept-Language': locale,
        },
      ),
    );
    return forward(req);
  }
}
