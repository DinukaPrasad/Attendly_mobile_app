import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/di/injection_container.dart';
import '../core/theme/app_dark_theme.dart';
import '../core/theme/app_light_theme.dart';
import '../core/theme/theme_controller.dart';
import '../core/routing/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ListenableBuilder(
          listenable: sl<ThemeController>(),
          builder: (context, _) {
            final themeController = sl<ThemeController>();
            return MaterialApp.router(
              title: 'Attendly',
              theme: AppLightTheme.build(),
              darkTheme: AppDarkTheme.build(),
              themeMode: themeController.themeMode,
              debugShowCheckedModeBanner: false,
              routerConfig: AppRouter.router,
            );
          },
        );
      },
    );
  }
}
