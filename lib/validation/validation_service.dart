import 'package:risiko_simulator/state/battle_state.dart';

import 'validation_result.dart';

class ValidationService {
  static const int minValue = 1;
  static const int maxValue = 128;

  ValidationService._();

  static ValidationResult validate({required int? attackers, required int? defenders, required AttackMode attackMode}) {
    FieldError? attackersError = ValidationService._getInputError(attackers, attackMode);
    FieldError? defendersError = ValidationService._getInputError(defenders, attackMode);

    return ValidationResult(attackersError: attackersError, defendersError: defendersError);
  }

  static FieldError? _getInputError(int? inputValue, AttackMode attackMode) {
    int minValue = attackMode == AttackMode.allIn ? 1 : 3;
    int maxValue = 128;

    if (inputValue == null) {
      return FieldError(type: ErrorType.missing, minValue: minValue, maxValue: maxValue, attackMode: attackMode);
    }

    if (inputValue < minValue) {
      return FieldError(type: ErrorType.belowMinimum, minValue: minValue, maxValue: maxValue, attackMode: attackMode);
    }

    if (inputValue > maxValue) {
      return FieldError(type: ErrorType.aboveMaximum, minValue: minValue, maxValue: maxValue, attackMode: attackMode);
    }

    return null;
  }
}
