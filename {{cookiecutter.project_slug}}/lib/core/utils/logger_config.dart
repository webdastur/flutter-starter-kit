import 'package:flutter/foundation.dart';
import 'package:talker/talker.dart';

class LoggerConfig {
  static Talker createTalker() {
    // Force enable colors for iTerm2 and other ANSI-capable terminals
    final enableColors = kDebugMode; // Always enable in debug mode for iTerm2

    return Talker(
      settings: TalkerSettings(
        useConsoleLogs: true,
        useHistory: true,
        maxHistoryItems: kDebugMode ? 200 : 50,
      ),
      logger: TalkerLogger(
        settings: TalkerLoggerSettings(
          enableColors: enableColors, // Enable colors for iTerm2
        ),
      ),
    );
  }
}
