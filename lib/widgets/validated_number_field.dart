import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/input_validator.dart';

class ValidatedNumberField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isInvalid;
  final InputValidator validator;

  const ValidatedNumberField({
    super.key,
    required this.controller,
    required this.label,
    required this.isInvalid,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: validator.isFieldRedForInput(controller.text, isInvalid) ? Colors.red : Colors.grey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: validator.isFieldRedForInput(controller.text, isInvalid) ? Colors.red : Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: validator.isFieldRedForInput(controller.text, isInvalid) ? Colors.red : Colors.blue,
          ),
        ),
        counterText: '',
        labelStyle: TextStyle(color: validator.isFieldRedForInput(controller.text, isInvalid) ? Colors.red : null),
        suffixText: validator.getSuffixTextForInput(controller.text, isInvalid),
        suffixStyle: const TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }
}
