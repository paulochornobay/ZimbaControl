import 'package:drift/drift.dart';

QueryExecutor openConnection() {
  throw UnsupportedError(
    'No database connection is available on this platform.',
  );
}
