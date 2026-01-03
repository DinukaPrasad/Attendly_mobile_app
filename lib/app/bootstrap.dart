import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'bloc/app_bloc.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appBloc = AppBloc();
  runApp(
    BlocProvider.value(
      value: appBloc,
      child: const App(),
    ),
  );
}
