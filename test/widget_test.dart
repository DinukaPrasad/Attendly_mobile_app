// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:attendly/app/app.dart';
import 'package:attendly/app/bloc/app_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  testWidgets('Shows login when unauthenticated', (WidgetTester tester) async {
    final appBloc = AppBloc();

    await tester.pumpWidget(
      BlocProvider.value(
        value: appBloc,
        child: const App(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Login'), findsOneWidget);
  });
}
