// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:risiko_simulator/main.dart';

void main() {
  testWidgets('Battle simulator UI test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RisikoApp());

    // Verify that the app has the expected UI elements.
    expect(find.text('Enter Battle Parameters'), findsOneWidget);
    expect(find.text('Number of Attackers'), findsOneWidget);
    expect(find.text('Number of Defenders'), findsOneWidget);
    expect(find.text('GO'), findsOneWidget);

    // Test entering values and pressing GO button
    await tester.enterText(find.byType(TextField).first, '10');
    await tester.enterText(find.byType(TextField).last, '5');
    await tester.tap(find.text('GO'));
    await tester.pump();

    // Verify that the result is displayed
    expect(find.textContaining('Simulating battle: 10 attackers vs 5 defenders'), findsOneWidget);
  });
}
