import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/config/env.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_dimensions.dart';

/// Demo page showing environment configuration and feature flags
class EnvDemoPage extends HookWidget {
  const EnvDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Environment Configuration',
          style: TextStyle(
            fontSize: AppTypography.titleLarge,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.screenPaddingHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppDimensions.spacingMd),

            // App Configuration Section
            _buildSection(context, 'App Configuration', Icons.settings, [
              _buildInfoRow('App Name', AppConstants.appName),
              _buildInfoRow('Version', Env.appVersion),
              _buildInfoRow(
                'Debug Mode',
                AppConstants.isDebugMode ? 'Enabled' : 'Disabled',
              ),
            ]),

            SizedBox(height: AppDimensions.spacingLg),

            // API Configuration Section
            _buildSection(context, 'API Configuration', Icons.cloud, [
              _buildInfoRow('Base URL', AppConstants.baseUrl),
              _buildInfoRow('Timeout', '${AppConstants.apiTimeoutMs}ms'),
              _buildInfoRow('Todos Endpoint', AppConstants.todosEndpoint),
            ]),

            SizedBox(height: AppDimensions.spacingLg),

            // Feature Flags Section
            _buildSection(context, 'Feature Flags', Icons.flag, [
              _buildFeatureFlag('Logging', AppConstants.isLoggingEnabled),
              _buildFeatureFlag(
                'Crash Reporting',
                AppConstants.isCrashReportingEnabled,
              ),
              _buildFeatureFlag('Analytics', AppConstants.isAnalyticsEnabled),
            ]),

            SizedBox(height: AppDimensions.spacingLg),

            // Third-party Services Section
            _buildSection(context, 'Third-party Services', Icons.extension, [
              _buildServiceStatus('Firebase', AppConstants.hasFirebaseConfig),
              _buildServiceStatus('Sentry', AppConstants.hasSentryConfig),
              _buildServiceStatus('Mixpanel', AppConstants.hasMixpanelConfig),
            ]),

            SizedBox(height: AppDimensions.spacingLg),

            // Environment Variables Section
            if (kDebugMode) ...[
              _buildSection(context, 'Raw Environment Variables', Icons.code, [
                _buildInfoRow('API_BASE_URL', Env.apiBaseUrl),
                _buildInfoRow('API_TIMEOUT', Env.apiTimeout),
                _buildInfoRow('DEBUG_MODE', Env.debugMode),
                _buildInfoRow('ENABLE_LOGGING', Env.enableLogging),
                _buildInfoRow(
                  'ENABLE_CRASH_REPORTING',
                  Env.enableCrashReporting,
                ),
                _buildInfoRow('ENABLE_ANALYTICS', Env.enableAnalytics),
                _buildInfoRow(
                  'FIREBASE_API_KEY',
                  Env.firebaseApiKey.isEmpty ? '(not set)' : '***hidden***',
                ),
                _buildInfoRow(
                  'SENTRY_DSN',
                  Env.sentryDsn.isEmpty ? '(not set)' : '***hidden***',
                ),
                _buildInfoRow(
                  'MIXPANEL_TOKEN',
                  Env.mixpanelToken.isEmpty ? '(not set)' : '***hidden***',
                ),
              ]),

              SizedBox(height: AppDimensions.spacingLg),
            ],

            // Instructions Card
            _buildInstructionsCard(context),

            SizedBox(height: AppDimensions.spacingXl),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    return Card(
      elevation: AppDimensions.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: AppDimensions.iconMd,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: AppDimensions.sm),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppTypography.titleMedium,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppDimensions.spacingMd),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.spacingSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppTypography.bodyMedium,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: AppTypography.bodyMedium,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureFlag(String feature, bool isEnabled) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.spacingSm),
      child: Row(
        children: [
          Icon(
            isEnabled ? Icons.check_circle : Icons.cancel,
            color: isEnabled ? Colors.green : Colors.red,
            size: AppDimensions.iconSm,
          ),
          SizedBox(width: AppDimensions.sm),
          Text(
            feature,
            style: TextStyle(
              fontSize: AppTypography.bodyMedium,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.sm,
              vertical: 2.h,
            ),
            decoration: BoxDecoration(
              color: isEnabled
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
            ),
            child: Text(
              isEnabled ? 'Enabled' : 'Disabled',
              style: TextStyle(
                fontSize: AppTypography.labelSmall,
                fontWeight: FontWeight.w600,
                color: isEnabled ? Colors.green[700] : Colors.red[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceStatus(String service, bool isConfigured) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.spacingSm),
      child: Row(
        children: [
          Icon(
            isConfigured ? Icons.cloud_done : Icons.cloud_off,
            color: isConfigured ? Colors.blue : Colors.grey,
            size: AppDimensions.iconSm,
          ),
          SizedBox(width: AppDimensions.sm),
          Text(
            service,
            style: TextStyle(
              fontSize: AppTypography.bodyMedium,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.sm,
              vertical: 2.h,
            ),
            decoration: BoxDecoration(
              color: isConfigured
                  ? Colors.blue.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
            ),
            child: Text(
              isConfigured ? 'Configured' : 'Not Set',
              style: TextStyle(
                fontSize: AppTypography.labelSmall,
                fontWeight: FontWeight.w600,
                color: isConfigured ? Colors.blue[700] : Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionsCard(BuildContext context) {
    return Card(
      color: Colors.blue.withOpacity(0.05),
      elevation: AppDimensions.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: AppDimensions.iconMd,
                  color: Colors.blue[600],
                ),
                SizedBox(width: AppDimensions.sm),
                Text(
                  'Environment Setup Instructions',
                  style: TextStyle(
                    fontSize: AppTypography.titleSmall,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppDimensions.spacingMd),
            Text(
              '1. Create a .env file in the project root\n'
              '2. Copy the template from lib/core/config/env_template.txt\n'
              '3. Add your actual API keys and configuration\n'
              '4. Run: flutter packages pub run build_runner build\n'
              '5. Make sure .env is added to .gitignore',
              style: TextStyle(
                fontSize: AppTypography.bodyMedium,
                height: 1.5,
                color: Colors.blue[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
