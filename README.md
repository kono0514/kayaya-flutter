# kayaya_flutter

[![Build Status](https://app.bitrise.io/app/af14e8c20650eb44/status.svg?token=3qLpr8MxbMQcWRWM0AUOwA&branch=master)](https://app.bitrise.io/app/af14e8c20650eb44)

A new Flutter project.

## Download / Update schema files

```bash
yarn dl-schema
```

## Regenerating Dart types from GraphQL queries using Artemis

You should regenrate types if the schema has changed or you modified a query in /graphql/aniim or /graphql/anilist directory.

```bash
yarn gen-dart-types
```
