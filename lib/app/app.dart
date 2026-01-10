import 'package:flutter/material.dart';

import '../core/routing/app_router.dart';
import '../core/theme/app_theme.dart';
import '../features/attendance/presentation/pages/scan_screen.dart';
import '../features/auth/presentation/widgets/auth_gate.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendly',
      theme: AppTheme.light,
      // Use AuthGate as home - it will show Login or ScanScreen based on auth state
      home: const AuthGate(child: ScanScreen()),
      routes: AppRoutes.routes,
    );
  }
}
