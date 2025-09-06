import '../config/env.dart';

class AppConstants {
  // App Configuration from Environment
  static String get appName => Env.appName;
  static String get baseUrl => Env.apiBaseUrl;
  static int get apiTimeoutMs => Env.apiTimeoutMs;

  // Feature Flags from Environment
  static bool get isDebugMode => Env.isDebugMode;
  static bool get isLoggingEnabled => Env.isLoggingEnabled;
  static bool get isCrashReportingEnabled => Env.isCrashReportingEnabled;
  static bool get isAnalyticsEnabled => Env.isAnalyticsEnabled;

  // API Endpoints
  static const String todosEndpoint = '/todos';

  // Hive Box Names
  static const String todoBoxName = 'todos';

  // Localization
  static const List<String> supportedLocales = ['en', 'es'];
  static const String defaultLocale = 'en';

  // Third-party Service Configuration
  static bool get hasFirebaseConfig => Env.hasFirebaseConfig;
  static bool get hasSentryConfig => Env.hasSentryConfig;
  static bool get hasMixpanelConfig => Env.hasMixpanelConfig;
}
