import 'package:flutter_screenutil/flutter_screenutil.dart';

/// App-wide responsive dimensions using ScreenUtil
class AppDimensions {
  // Private constructor to prevent instantiation
  AppDimensions._();

  /// Spacing constants
  static double get xs => 4.w;
  static double get sm => 8.w;
  static double get md => 16.w;
  static double get lg => 24.w;
  static double get xl => 32.w;
  static double get xxl => 48.w;

  /// Vertical spacing
  static double get spacingXs => 4.h;
  static double get spacingSm => 8.h;
  static double get spacingMd => 16.h;
  static double get spacingLg => 24.h;
  static double get spacingXl => 32.h;
  static double get spacingXxl => 48.h;

  /// Border radius
  static double get radiusXs => 4.r;
  static double get radiusSm => 8.r;
  static double get radiusMd => 12.r;
  static double get radiusLg => 16.r;
  static double get radiusXl => 24.r;
  static double get radiusRound => 50.r;

  /// Icon sizes
  static double get iconXs => 16.sp;
  static double get iconSm => 20.sp;
  static double get iconMd => 24.sp;
  static double get iconLg => 32.sp;
  static double get iconXl => 48.sp;

  /// Button dimensions
  static double get buttonHeight => 48.h;
  static double get buttonHeightSmall => 36.h;
  static double get buttonHeightLarge => 56.h;
  static double get buttonMinWidth => 120.w;

  /// Card dimensions
  static double get cardElevation => 2.0;
  static double get cardRadius => radiusMd;
  static double get cardPadding => md;

  /// Form field dimensions
  static double get inputHeight => 56.h;
  static double get inputPadding => md;
  static double get inputRadius => radiusSm;

  /// App bar dimensions
  static double get appBarHeight => 56.h;
  static double get toolbarHeight => 56.h;

  /// Bottom navigation
  static double get bottomNavHeight => 80.h;
  static double get bottomNavIconSize => iconMd;

  /// FAB dimensions
  static double get fabSize => 56.sp;
  static double get fabSizeSmall => 40.sp;
  static double get fabSizeLarge => 72.sp;

  /// List item dimensions
  static double get listItemHeight => 72.h;
  static double get listItemPadding => md;
  static double get listItemSpacing => spacingSm;

  /// Screen padding (safe area aware)
  static double get screenPaddingHorizontal => md;
  static double get screenPaddingVertical => spacingMd;

  /// Modal dimensions
  static double get modalRadius => radiusLg;
  static double get modalPadding => lg;
  static double get modalMaxWidth => 400.w;

  /// Mobile-focused screen breakpoints
  static bool get isCompactPhone =>
      1.sw < 360; // Small phones (iPhone SE, etc.)
  static bool get isStandardPhone =>
      1.sw >= 360 && 1.sw < 430; // Standard phones
  static bool get isLargePhone =>
      1.sw >= 430; // Large phones (iPhone Pro Max, etc.)

  /// Mobile screen type helper
  static String get phoneType {
    if (isCompactPhone) return 'Compact';
    if (isStandardPhone) return 'Standard';
    return 'Large';
  }

  /// Mobile-optimized grid columns (always 1 for mobile)
  static int get gridColumns => 1;

  /// Mobile-optimized card width
  static double get cardWidth => 1.sw - (screenPaddingHorizontal * 2);

  /// Mobile-specific list item height adjustments
  static double get listItemHeightCompact =>
      isCompactPhone ? 64.h : listItemHeight;

  /// Mobile-specific button height adjustments
  static double get buttonHeightMobile => isCompactPhone ? 44.h : buttonHeight;
}

/// Typography dimensions using ScreenUtil
class AppTypography {
  AppTypography._();

  // Font sizes
  static double get displayLarge => 57.sp;
  static double get displayMedium => 45.sp;
  static double get displaySmall => 36.sp;

  static double get headlineLarge => 32.sp;
  static double get headlineMedium => 28.sp;
  static double get headlineSmall => 24.sp;

  static double get titleLarge => 22.sp;
  static double get titleMedium => 16.sp;
  static double get titleSmall => 14.sp;

  static double get labelLarge => 14.sp;
  static double get labelMedium => 12.sp;
  static double get labelSmall => 11.sp;

  static double get bodyLarge => 16.sp;
  static double get bodyMedium => 14.sp;
  static double get bodySmall => 12.sp;

  // Line heights
  static double get lineHeightTight => 1.2;
  static double get lineHeightNormal => 1.4;
  static double get lineHeightLoose => 1.6;

  // Letter spacing
  static double get letterSpacingTight => -0.5.sp;
  static double get letterSpacingNormal => 0.0;
  static double get letterSpacingWide => 0.5.sp;
}
