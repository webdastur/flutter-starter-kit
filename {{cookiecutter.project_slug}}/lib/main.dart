import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'presentation/todos/bloc/todo_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize easy_localization
  await EasyLocalization.ensureInitialized();

  // Configure dependencies
  await configureDependencies();

  // Set up Bloc observer for logging
  Bloc.observer = TalkerBlocObserver(
    talker: getIt(),
    settings: const TalkerBlocLoggerSettings(
      printStateFullData: true,
      printEventFullData: true,
      printTransitions: true,
      printEvents: true,
      printCreations: true,
      printClosings: true,
    ),
  );

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('es')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // Design size optimized for mobile phones (iPhone 14 Pro)
      designSize: const Size(393, 852),
      // Minimum text adaptation for mobile readability
      minTextAdapt: true,
      // Disable split screen mode for mobile-only app
      splitScreenMode: false,
      // Use system font scaling for accessibility
      useInheritedMediaQuery: true,
      // Ensure mobile-first responsive behavior
      ensureScreenSize: true,
      builder: (context, child) {
        return BlocProvider(
          create: (context) => getIt<TodoBloc>(),
          child: MaterialApp.router(
            title: 'app.title'.tr(),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              appBarTheme: AppBarTheme(
                centerTitle: true,
                elevation: 0,
                titleTextStyle: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              cardTheme: CardThemeData(
                elevation: 2,
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              ),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                elevation: 4,
              ),
              // Responsive text theme
              textTheme: TextTheme(
                headlineLarge: TextStyle(fontSize: 32.sp),
                headlineMedium: TextStyle(fontSize: 28.sp),
                headlineSmall: TextStyle(fontSize: 24.sp),
                titleLarge: TextStyle(fontSize: 22.sp),
                titleMedium: TextStyle(fontSize: 16.sp),
                titleSmall: TextStyle(fontSize: 14.sp),
                bodyLarge: TextStyle(fontSize: 16.sp),
                bodyMedium: TextStyle(fontSize: 14.sp),
                bodySmall: TextStyle(fontSize: 12.sp),
                labelLarge: TextStyle(fontSize: 14.sp),
                labelMedium: TextStyle(fontSize: 12.sp),
                labelSmall: TextStyle(fontSize: 11.sp),
              ),
            ),
            routerConfig: AppRouter.router,
          ),
        );
      },
    );
  }
}
