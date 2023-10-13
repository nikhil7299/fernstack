import 'dart:developer' as devtools show log;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_logger/talker_logger.dart';

extension Log on Object? {
  void log() => devtools.log(toString());
}

// get talker -dio logger for http calls

//talker logger for state

final tlog = TalkerLogger(
    settings: const TalkerLoggerSettings(
  maxLineWidth: 80,
));

/// Useful to log state change in our application
/// Read the logs and you'll better understand what's going on under the hood
class StateLogger extends ProviderObserver {
  const StateLogger();

  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    tlog.good('''provider: ${provider.runtimeType}
oldValue: $previousValue
newValue: $newValue''');
//     '''provider: ${provider.runtimeType}
// oldValue: $previousValue
// newValue: $newValue'''
//         .log();
  }
}
