import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:risiko_simulator/app/risiko_app.dart';
import 'package:risiko_simulator/state/battle_state.dart';

void main() {
  testWidgets('Battle simulator UI test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => BattleState(),
        child: const RisikoApp(),
      ),
    );

    expect(find.text('Anzahl Angreifer'), findsOneWidget);
    expect(find.text('Anzahl Verteidiger'), findsOneWidget);
    expect(find.text('Sicherer Angriff'), findsOneWidget);
    expect(find.text('Chancen berechnen'), findsOneWidget);
    expect(find.text('Ergebnis simulieren'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, '10');
    await tester.enterText(find.byType(TextField).last, '5');
    await tester.tap(find.text('Ergebnis simulieren'));
    await tester.pump();

    expect(find.textContaining('🟢 SIEG DES ANGREIFERS!'), findsOneWidget);
  });
}
