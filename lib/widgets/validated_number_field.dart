import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../state/battle_state.dart';
import '../validation/validation_message_formatter.dart';

class ValidatedNumberField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isAttackerField;

  const ValidatedNumberField({super.key, required this.controller, required this.label, this.isAttackerField = false});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BattleState>();
    final error = isAttackerField ? state.validationResult.attackersError : state.validationResult.defendersError;
    final touched = isAttackerField ? state.attackersTouched : state.defendersTouched;
    final isRed = error != null && (touched || state.shouldShowErrors);
    final suffixText = (touched || state.shouldShowErrors) ? ValidationMessageFormatter.getSuffixText(error) : null;

    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (text) {
        final value = int.tryParse(text);
        if (isAttackerField) {
          context.read<BattleState>().setAttackers(value);
        } else {
          context.read<BattleState>().setDefenders(value);
        }
      },
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderSide: BorderSide(color: isRed ? Colors.red : Colors.grey)),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: isRed ? Colors.red : Colors.grey)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: isRed ? Colors.red : Colors.blue)),
        counterText: '',
        labelStyle: TextStyle(color: isRed ? Colors.red : null),
        suffixText: suffixText,
        suffixStyle: const TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }
}
