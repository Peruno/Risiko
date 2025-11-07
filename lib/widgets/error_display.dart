import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/battle_state.dart';
import '../validation/validation_message_formatter.dart';

class ErrorDisplay extends StatelessWidget {
  const ErrorDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BattleState>(
      builder: (context, state, child) {
        if (!state.shouldShowErrors) return const SizedBox.shrink();

        final errorBoxText = ValidationMessageFormatter.getErrorBoxText(state.validationResult);
        if (errorBoxText == null) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(errorBoxText, style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
        );
      },
    );
  }
}
