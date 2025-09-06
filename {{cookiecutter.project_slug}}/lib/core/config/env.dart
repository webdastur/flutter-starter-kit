import 'package:envied/envied.dart';

part 'env.g.dart';

/// Environment variables configuration using Envied
///
/// To use this:
/// 1. Create a .env file in the project root
/// 2. Add your environment variables to .env
/// 3. Run: flutter packages pub run build_runner build
///
/// Example .env file:
/// API_BASE_URL=https://dummyjson.com
/// API_TIMEOUT=30000
/// APP_NAME={{ cookiecutter.project_name }}
/// DEBUG_MODE=true
@Envied(path: '.env')
abstract class Env {
  /// API Configuration
  @EnviedField(varName: 'API_BASE_URL', defaultValue: 'https://dummyjson.com')
  static const String apiBaseUrl = _Env.apiBaseUrl;

  @EnviedField(varName: 'API_TIMEOUT', defaultValue: '30000')
  static const String apiTimeout = _Env.apiTimeout;

  /// App Configuration
  @EnviedField(
    varName: 'APP_NAME',
    defaultValue: '{{ cookiecutter.project_name }}',
  )
  static const String appName = _Env.appName;

  @EnviedField(varName: 'APP_VERSION', defaultValue: '1.0.0')
  static const String appVersion = _Env.appVersion;

  @EnviedField(varName: 'DEBUG_MODE', defaultValue: 'true')
  static const String debugMode = _Env.debugMode;

  /// Feature Flags
  @EnviedField(varName: 'ENABLE_LOGGING', defaultValue: 'true')
  static const String enableLogging = _Env.enableLogging;

  @EnviedField(varName: 'ENABLE_CRASH_REPORTING', defaultValue: 'false')
  static const String enableCrashReporting = _Env.enableCrashReporting;

  @EnviedField(varName: 'ENABLE_ANALYTICS', defaultValue: 'false')
  static const String enableAnalytics = _Env.enableAnalytics;

  /// Third-party Services (optional)
  @EnviedField(varName: 'FIREBASE_API_KEY', defaultValue: '')
  static const String firebaseApiKey = _Env.firebaseApiKey;

  @EnviedField(varName: 'SENTRY_DSN', defaultValue: '')
  static const String sentryDsn = _Env.sentryDsn;

  @EnviedField(varName: 'MIXPANEL_TOKEN', defaultValue: '')
  static const String mixpanelToken = _Env.mixpanelToken;

  /// Convenience getters with proper type conversion
  static bool get isDebugMode => debugMode.toLowerCase() == 'true';
  static bool get isLoggingEnabled => enableLogging.toLowerCase() == 'true';
  static bool get isCrashReportingEnabled =>
      enableCrashReporting.toLowerCase() == 'true';
  static bool get isAnalyticsEnabled => enableAnalytics.toLowerCase() == 'true';

  static int get apiTimeoutMs => int.tryParse(apiTimeout) ?? 30000;

  /// Check if third-party services are configured
  static bool get hasFirebaseConfig => firebaseApiKey.isNotEmpty;
  static bool get hasSentryConfig => sentryDsn.isNotEmpty;
  static bool get hasMixpanelConfig => mixpanelToken.isNotEmpty;
}
