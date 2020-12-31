class EnvironmentConfig {
  static const graphqlServerEndpoint = String.fromEnvironment(
    'KAYAYA_GRAPHQL_SERVER',
    defaultValue: 'http://aniim-api.test/graphql',
  );
  static const updateServerEndpoint = String.fromEnvironment(
    'KAYAYA_UPDATE_SERVER',
    defaultValue: 'http://aniim-api.test/v1/update',
  );
}
