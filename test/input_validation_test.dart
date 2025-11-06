import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:risiko_simulator/app/risiko_app.dart';
import 'package:risiko_simulator/state/battle_state.dart';

void main() {
  group('Input Validation Behavior', () {
    Widget createTestApp() {
      return ChangeNotifierProvider(
        create: (_) => BattleState(),
        child: const RisikoApp(),
      );
    }

    Finder attackerField() => find.byKey(const Key('attacker_field'));
    Finder defenderField() => find.byKey(const Key('defender_field'));

    bool isFieldRed(WidgetTester tester, Finder field) {
      final textFieldFinder = find.descendant(of: field, matching: find.byType(TextField));
      final textField = tester.widget<TextField>(textFieldFinder);
      final decoration = textField.decoration as InputDecoration;
      final borderColor = (decoration.enabledBorder as OutlineInputBorder).borderSide.color;
      return borderColor == Colors.red;
    }

    testWidgets('Defender field: valid and invalid ranges', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());

      await tester.enterText(defenderField(), '0');
      await tester.pump();
      expect(isFieldRed(tester, defenderField()), true);

      await tester.enterText(defenderField(), '129');
      await tester.pump();
      expect(isFieldRed(tester, defenderField()), true);

      final randomValid = Random().nextInt(128) + 1;
      await tester.enterText(defenderField(), randomValid.toString());
      await tester.pump();
      expect(isFieldRed(tester, defenderField()), false);
    });

    testWidgets('Attacker field: valid and invalid ranges in "All-In" mode', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());

      await tester.enterText(attackerField(), '0');
      await tester.pump();
      expect(isFieldRed(tester, attackerField()), true);

      await tester.enterText(attackerField(), '129');
      await tester.pump();
      expect(isFieldRed(tester, attackerField()), true);

      final randomValid = Random().nextInt(128) + 1;
      await tester.enterText(attackerField(), randomValid.toString());
      await tester.pump();
      expect(isFieldRed(tester, attackerField()), false);
    });

    testWidgets('Attacker field: valid and invalid ranges in "Sicherer Angriff" mode', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());

      await tester.tap(find.text('Sicherer Angriff'));
      await tester.pump();

      await tester.enterText(attackerField(), '2');
      await tester.pump();
      expect(isFieldRed(tester, attackerField()), true);

      await tester.enterText(attackerField(), '129');
      await tester.pump();
      expect(isFieldRed(tester, attackerField()), true);

      final randomValid = Random().nextInt(126) + 3;
      await tester.enterText(attackerField(), randomValid.toString());
      await tester.pump();
      expect(isFieldRed(tester, attackerField()), false);
    });

    testWidgets('Error box appears when field is invalid', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());

      await tester.enterText(attackerField(), '0');
      await tester.enterText(defenderField(), '5');
      await tester.pump();

      expect(find.textContaining('Angreifer muss mindestens'), findsOneWidget);
    });

    testWidgets('Error box disappears when input becomes valid', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());

      await tester.enterText(attackerField(), '0');
      await tester.enterText(defenderField(), '5');
      await tester.pump();
      expect(find.textContaining('Angreifer'), findsWidgets);

      await tester.enterText(attackerField(), '5');
      await tester.pump();

      expect(find.textContaining('Angreifer muss mindestens'), findsNothing);
    });

    testWidgets('Attack mode change triggers revalidation', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());

      await tester.enterText(attackerField(), '2');
      await tester.enterText(defenderField(), '5');
      await tester.pump();

      expect(isFieldRed(tester, attackerField()), false);
      expect(find.textContaining('Angreifer muss'), findsNothing);

      await tester.tap(find.text('Sicherer Angriff'));
      await tester.pump();

      expect(isFieldRed(tester, attackerField()), true);
      expect(find.textContaining('Angreifer muss mindestens 3'), findsOneWidget);
    });

    testWidgets('Input change triggers revalidation', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());

      await tester.enterText(attackerField(), '5');
      await tester.pump();
      expect(isFieldRed(tester, attackerField()), false);

      await tester.enterText(attackerField(), '0');
      await tester.pump();
      expect(isFieldRed(tester, attackerField()), true);

      await tester.enterText(attackerField(), '10');
      await tester.pump();
      expect(isFieldRed(tester, attackerField()), false);
    });
  });
}
