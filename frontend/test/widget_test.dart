// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/main.dart';

void main() {
  testWidgets('shows the login form', (WidgetTester tester) async {
    await tester.pumpWidget(const EmployeeMonitorApp());

    expect(find.text('Loading.'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1800));
    await tester.pump();

    expect(find.text('verinite'), findsNWidgets(2));
    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });
}
