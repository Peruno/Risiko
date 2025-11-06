import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/input_validator.dart';

class ValidatedNumberField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isInvalid;
  final InputValidator validator;
  final bool isAttackerField;

  const ValidatedNumberField({
    super.key,
    required this.controller,
    required this.label,
    required this.isInvalid,
    required this.validator,
    this.isAttackerField = false,
  });

  @override
  Widget build(BuildContext context) {
    final value = int.tryParse(controller.text);
    final isRed = validator.isFieldRedForInput(isInvalid, value);

    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderSide: BorderSide(color: isRed ? Colors.red : Colors.grey)),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: isRed ? Colors.red : Colors.grey)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: isRed ? Colors.red : Colors.blue)),
        counterText: '',
        labelStyle: TextStyle(color: isRed ? Colors.red : null),
        suffixText: validator.getSuffixTextForInput(isInvalid, value, isAttackerField: isAttackerField),
        suffixStyle: const TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }
}
