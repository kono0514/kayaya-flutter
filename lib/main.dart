import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'app.dart';
import 'core/utils/simple_bloc_observer.dart';
import 'core/utils/utils.dart';
import 'injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SentryFlutter.init(
    (options) => options
      ..dsn =
          'https://f8cbc63ea9524db6a0ffe2e7a6f6334d@o465414.ingest.sentry.io/5557914'
      ..beforeSend = (SentryEvent event, {dynamic hint}) {
        if (!kReleaseMode) {
          return null;
        }
        return event;
      },
    appRunner: () async {
      await configureDependencies();

      Bloc.observer = SimpleBlocObserver();

      runApp(const AppWrapper());
    },
  );
}
