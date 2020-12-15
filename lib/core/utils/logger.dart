import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

final Logger logger = Logger(printer: PrettyPrinter());

void errorLog(dynamic e, [StackTrace s]) {
  logger.e(e, null, s);
  Sentry.captureException(
    e,
    stackTrace: s,
  );
}
