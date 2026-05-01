import 'package:flutter/material.dart';

import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';
import 'core/network/api_client.dart';
import 'core/services/storage_service.dart';
import 'domain/entities/user.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/login/login_screen.dart';

void main() {
  runApp(const AttendlyApp());
}

class AttendlyApp extends StatefulWidget {
  const AttendlyApp({super.key});

  @override
  State<AttendlyApp> createState() => _AttendlyAppState();
}

class _AttendlyAppState extends State<AttendlyApp> {
  late Future<Widget> _initialRoute;

  @override
  void initState() {
    super.initState();
    _initialRoute = _determineInitialRoute();
  }

  Future<Widget> _determineInitialRoute() async {
    final token = await StorageService.getToken();
    final userJson = await StorageService.getUser();

    if (token != null && userJson != null) {
      try {
        ApiClient.setGlobalToken(token);
        // Parse user JSON
        final userMap = _parseUserJson(userJson);
        final user = User(
          id: userMap['id'] ?? '',
          name: userMap['name'] ?? '',
          email: userMap['email'] ?? '',
          token: token,
          role: userMap['role'],
        );
        return HomeScreen(user: user);
      } catch (_) {
        return const LoginScreen();
      }
    }

    return const LoginScreen();
  }

  Map<String, dynamic> _parseUserJson(String json) {
    // Simple JSON parsing without external dependencies
    // Extracts id, name, email, and token from JSON string
    final idMatch = RegExp(r'"id":"([^"]*)"').firstMatch(json);
    final nameMatch = RegExp(r'"name":"([^"]*)"').firstMatch(json);
    final emailMatch = RegExp(r'"email":"([^"]*)"').firstMatch(json);
    final tokenMatch = RegExp(r'"token":"([^"]*)"').firstMatch(json);
    final roleMatch = RegExp(r'"role":"([^"]*)"').firstMatch(json);

    return {
      'id': idMatch?.group(1) ?? '',
      'name': nameMatch?.group(1) ?? '',
      'email': emailMatch?.group(1) ?? '',
      'token': tokenMatch?.group(1),
      'role': roleMatch?.group(1),
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _initialRoute,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            title: AppStrings.appName,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
              useMaterial3: true,
            ),
            home: Scaffold(
              backgroundColor: AppColors.background,
              body: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              ),
            ),
          );
        }

        return MaterialApp(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
            useMaterial3: true,
          ),
          home: snapshot.data ?? const LoginScreen(),
        );
      },
    );
  }
}
