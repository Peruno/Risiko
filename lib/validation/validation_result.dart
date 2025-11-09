import 'package:risiko_simulator/state/battle_state.dart';

enum ErrorType { missing, belowMinimum, aboveMaximum }

class FieldError {
  final ErrorType type;
  final int minValue;
  final int maxValue;
  final AttackMode attackMode;

  const FieldError({
    required this.type,
    required this.minValue,
    required this.maxValue,
    required this.attackMode,
  });
}

class ValidationResult {
  final FieldError? attackersError;
  final FieldError? defendersError;

  const ValidationResult({this.attackersError, this.defendersError});

  bool get isValid => attackersError == null && defendersError == null;
}
