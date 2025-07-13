import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:risiko_simulator/main.dart';

void main() {
  testWidgets('Battle simulator UI test', (WidgetTester tester) async {
    await tester.pumpWidget(const RisikoApp());

    expect(find.text('Anzahl Angreifer'), findsOneWidget);
    expect(find.text('Anzahl Verteidiger'), findsOneWidget);
    expect(find.text('Sicherer Angriff'), findsOneWidget);
    expect(find.text('Chancen berechnen'), findsOneWidget);
    expect(find.text('Schlacht starten'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, '10');
    await tester.enterText(find.byType(TextField).last, '5');
    await tester.tap(find.text('Schlacht starten'));
    await tester.pump();

    expect(find.textContaining('🟢 SIEG DES ANGREIFERS!'), findsOneWidget);
  });
}