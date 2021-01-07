# kayaya_flutter

[![Build Status](https://app.bitrise.io/app/af14e8c20650eb44/status.svg?token=3qLpr8MxbMQcWRWM0AUOwA&branch=master)](https://app.bitrise.io/app/af14e8c20650eb44)

A new Flutter project.

## Shader warmup before release

Warmup the skia shaders to reduce the first-install first-startup app jank.  
This is a manual process for now until https://github.com/flutter/flutter/issues/53609 is resolved.

Two ways to generate shaders:  

1. Interact with app manually.  
   Follow [this](https://flutter.dev/docs/perf/rendering/shader#how-to-use-sksl-warmup) guide's step 1-3 to generate ```flutter_**.sksl.json``` file.
```bash
flutter run --profile --cache-sksl --dart-define=KAYAYA_WARMUP_MODE=true
```

2. Use integration test to automate user interaction.
```bash
flutter run --profile --cache-sksl --dart-define=KAYAYA_WARMUP_MODE=true .\test_driver\integration.dart
flutter drive --write-sksl-on-exit --target=test_driver/integration.dart --use-existing-app=http://127.0.0.1:61163/*******=/
```

Finally rename the output file ```flutter_**.sksl.json``` to ```/flutter_shaders.sksl.json```. CI can pick this file and pack it in the release APK.

## Download / Update schema files

```bash
yarn dl-schema
```

## Regenerating Dart types from GraphQL queries using Artemis

You should regenrate types if the schema has changed or you modified a query in /graphql/aniim or /graphql/anilist directory.

```bash
yarn gen-dart-types
```
