import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/app_bloc.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AppRouter _router;

  @override
  void initState() {
    super.initState();
    final appBloc = context.read<AppBloc>();
    _router = AppRouter(appBloc);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Attendly',
      theme: AppTheme.light,
      routerConfig: _router.router,
    );
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }
}
