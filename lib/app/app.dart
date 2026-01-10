import 'package:flutter/material.dart';

import '../core/routing/app_router.dart';
import '../core/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendly',
      theme: AppTheme.light,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}
