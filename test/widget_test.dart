import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:risiko_simulator/main.dart';

void main() {
  testWidgets('Battle simulator UI test', (WidgetTester tester) async {
    await tester.pumpWidget(const RisikoApp());

    expect(find.text('Enter Battle Parameters'), findsOneWidget);
    expect(find.text('Number of Attackers'), findsOneWidget);
    expect(find.text('Number of Defenders'), findsOneWidget);
    expect(find.text('GO'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, '10');
    await tester.enterText(find.byType(TextField).last, '5');
    await tester.tap(find.text('GO'));
    await tester.pump();

    expect(find.textContaining('Simulating battle: 10 attackers vs 5 defenders'), findsOneWidget);
  });
}