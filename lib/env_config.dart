class EnvironmentConfig {
  static const graphqlServerEndpoint = String.fromEnvironment(
    'KAYAYA_GRAPHQL_SERVER',
    defaultValue: 'http://aniim-api.test/graphql',
  );
  static const appcenterUpdateServerEndpoint = String.fromEnvironment(
    'KAYAYA_APPCENTER_URL',
  );
  static const isWarmupMode = bool.fromEnvironment('KAYAYA_WARMUP_MODE');
}
