import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_dimensions.dart';

/// Demo page showcasing flutter_screenutil responsive design features
class ScreenUtilDemoPage extends HookWidget {
  const ScreenUtilDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTab = useState(0);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ScreenUtil Demo',
          style: TextStyle(
            fontSize: AppTypography.titleLarge,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Tab selection
          Container(
            margin: EdgeInsets.all(AppDimensions.md),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            child: Row(
              children: [
                _buildTabButton('Sizes', 0, selectedTab),
                _buildTabButton('Layout', 1, selectedTab),
                _buildTabButton('Text', 2, selectedTab),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppDimensions.screenPaddingHorizontal),
              child: _buildTabContent(selectedTab.value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(
    String title,
    int index,
    ValueNotifier<int> selectedTab,
  ) {
    final isSelected = selectedTab.value == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => selectedTab.value = index,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: AppDimensions.spacingSm,
            horizontal: AppDimensions.md,
          ),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppTypography.bodyMedium,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? Colors.black : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(int selectedTab) {
    switch (selectedTab) {
      case 0:
        return _buildSizesDemo();
      case 1:
        return _buildLayoutDemo();
      case 2:
        return _buildTextDemo();
      default:
        return _buildSizesDemo();
    }
  }

  Widget _buildSizesDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Screen Information'),
        _buildInfoCard([
          'Screen Width: ${1.sw.toStringAsFixed(1)}dp',
          'Screen Height: ${1.sh.toStringAsFixed(1)}dp',
          'Status Bar Height: ${ScreenUtil().statusBarHeight.toStringAsFixed(1)}dp',
          'Bottom Bar Height: ${ScreenUtil().bottomBarHeight.toStringAsFixed(1)}dp',
          'Text Scale Factor: ${ScreenUtil().textScaleFactor.toStringAsFixed(2)}',
          'Pixel Density: ${ScreenUtil().pixelRatio?.toStringAsFixed(2) ?? 'N/A'}',
        ]),

        SizedBox(height: AppDimensions.spacingLg),

        _buildSectionTitle('Responsive Sizes (.w, .h, .sp, .r)'),
        _buildDemoCard(
          child: Column(
            children: [
              _buildSizeDemo('50.w', 50.w, Colors.blue, isWidth: true),
              SizedBox(height: AppDimensions.spacingSm),
              _buildSizeDemo('100.w', 100.w, Colors.green, isWidth: true),
              SizedBox(height: AppDimensions.spacingSm),
              _buildSizeDemo('150.w', 150.w, Colors.orange, isWidth: true),
              SizedBox(height: AppDimensions.spacingMd),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSizeDemo('30.h', 30.h, Colors.red),
                  _buildSizeDemo('50.h', 50.h, Colors.purple),
                  _buildSizeDemo('70.h', 70.h, Colors.teal),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: AppDimensions.spacingLg),

        _buildSectionTitle('Border Radius (.r)'),
        _buildDemoCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildRadiusDemo('5.r', 5.r),
              _buildRadiusDemo('10.r', 10.r),
              _buildRadiusDemo('20.r', 20.r),
              _buildRadiusDemo('30.r', 30.r),
            ],
          ),
        ),

        SizedBox(height: AppDimensions.spacingLg),

        _buildSectionTitle('App Dimensions'),
        _buildInfoCard([
          'Phone Type: ${AppDimensions.phoneType}',
          'Compact Phone: ${AppDimensions.isCompactPhone}',
          'Standard Phone: ${AppDimensions.isStandardPhone}',
          'Large Phone: ${AppDimensions.isLargePhone}',
          'Card Width: ${AppDimensions.cardWidth.toStringAsFixed(1)}dp',
          'Button Height (Mobile): ${AppDimensions.buttonHeightMobile.toStringAsFixed(1)}dp',
          'List Item Height: ${AppDimensions.listItemHeightCompact.toStringAsFixed(1)}dp',
        ]),
      ],
    );
  }

  Widget _buildLayoutDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Mobile Grid Layout (Single Column)'),
        _buildDemoCard(
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: AppDimensions.gridColumns,
              crossAxisSpacing: AppDimensions.md,
              mainAxisSpacing: AppDimensions.md,
              childAspectRatio: 1.5,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.primaries[index % Colors.primaries.length]
                      .withOpacity(0.3),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Center(
                  child: Text(
                    'Item ${index + 1}',
                    style: TextStyle(
                      fontSize: AppTypography.bodyMedium,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        SizedBox(height: AppDimensions.spacingLg),

        _buildSectionTitle('Mobile-Optimized Card Layout'),
        _buildDemoCard(
          child: Column(
            children: [
              Container(
                width: AppDimensions.cardWidth,
                height: 120.h,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Mobile Card',
                        style: TextStyle(
                          fontSize: AppTypography.titleMedium,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: AppDimensions.spacingXs),
                      Text(
                        'Phone: ${AppDimensions.phoneType}',
                        style: TextStyle(
                          fontSize: AppTypography.bodySmall,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        'Width: ${AppDimensions.cardWidth.toStringAsFixed(1)}dp',
                        style: TextStyle(
                          fontSize: AppTypography.bodySmall,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: AppDimensions.spacingLg),

        _buildSectionTitle('Responsive Spacing'),
        _buildDemoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSpacingDemo('XS', AppDimensions.spacingXs),
              _buildSpacingDemo('SM', AppDimensions.spacingSm),
              _buildSpacingDemo('MD', AppDimensions.spacingMd),
              _buildSpacingDemo('LG', AppDimensions.spacingLg),
              _buildSpacingDemo('XL', AppDimensions.spacingXl),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Responsive Typography'),
        _buildDemoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTypographyDemo('Display Large', AppTypography.displayLarge),
              _buildTypographyDemo(
                'Display Medium',
                AppTypography.displayMedium,
              ),
              _buildTypographyDemo(
                'Headline Large',
                AppTypography.headlineLarge,
              ),
              _buildTypographyDemo(
                'Headline Medium',
                AppTypography.headlineMedium,
              ),
              _buildTypographyDemo('Title Large', AppTypography.titleLarge),
              _buildTypographyDemo('Title Medium', AppTypography.titleMedium),
              _buildTypographyDemo('Body Large', AppTypography.bodyLarge),
              _buildTypographyDemo('Body Medium', AppTypography.bodyMedium),
              _buildTypographyDemo('Body Small', AppTypography.bodySmall),
              _buildTypographyDemo('Label Large', AppTypography.labelLarge),
              _buildTypographyDemo('Label Medium', AppTypography.labelMedium),
              _buildTypographyDemo('Label Small', AppTypography.labelSmall),
            ],
          ),
        ),

        SizedBox(height: AppDimensions.spacingLg),

        _buildSectionTitle('Font Size Comparison'),
        _buildDemoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fixed Size (16px)',
                style: TextStyle(
                  fontSize: 16, // Fixed size
                  color: Colors.red,
                ),
              ),
              SizedBox(height: AppDimensions.spacingXs),
              Text(
                'Responsive Size (16.sp)',
                style: TextStyle(
                  fontSize: 16.sp, // Responsive size
                  color: Colors.green,
                ),
              ),
              SizedBox(height: AppDimensions.spacingMd),
              Text(
                'The green text adapts to different screen sizes and densities, while the red text remains fixed.',
                style: TextStyle(
                  fontSize: AppTypography.bodySmall,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.spacingSm),
      child: Text(
        title,
        style: TextStyle(
          fontSize: AppTypography.titleMedium,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDemoCard({required Widget child}) {
    return Card(
      elevation: AppDimensions.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.cardPadding),
        child: child,
      ),
    );
  }

  Widget _buildInfoCard(List<String> items) {
    return _buildDemoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) {
          return Padding(
            padding: EdgeInsets.only(bottom: AppDimensions.spacingXs),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: AppDimensions.iconSm,
                  color: Colors.blue,
                ),
                SizedBox(width: AppDimensions.sm),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(fontSize: AppTypography.bodyMedium),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSizeDemo(
    String label,
    double size,
    Color color, {
    bool isWidth = false,
  }) {
    return Column(
      children: [
        Container(
          width: isWidth ? size : 60.w,
          height: isWidth ? 30.h : size,
          decoration: BoxDecoration(
            color: color.withOpacity(0.7),
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: AppTypography.labelSmall,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRadiusDemo(String label, double radius) {
    return Column(
      children: [
        Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.3),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: Colors.purple),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: AppTypography.labelSmall,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSpacingDemo(String label, double spacing) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.spacingXs),
      child: Row(
        children: [
          SizedBox(
            width: 40.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppTypography.labelMedium,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            width: spacing,
            height: 20.h,
            color: Colors.orange.withOpacity(0.7),
          ),
          SizedBox(width: AppDimensions.sm),
          Text(
            '${spacing.toStringAsFixed(1)}dp',
            style: TextStyle(
              fontSize: AppTypography.labelSmall,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypographyDemo(String label, double fontSize) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.spacingXs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppTypography.labelMedium,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text('Sample Text', style: TextStyle(fontSize: fontSize)),
          ),
          Text(
            '${fontSize.toStringAsFixed(1)}sp',
            style: TextStyle(
              fontSize: AppTypography.labelSmall,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
