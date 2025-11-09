import 'package:risiko_simulator/state/battle_state.dart';

import 'validation_result.dart';

class ValidationService {
  static const int minValue = 1;
  static const int maxValue = 128;

  ValidationService._();

  static ValidationResult validate({required int? attackers, required int? defenders, required AttackMode attackMode}) {
    final minAttackers = attackMode == AttackMode.safe ? 3 : minValue;

    FieldError? attackersError;
    FieldError? defendersError;

    if (attackers == null) {
      attackersError = FieldError(
        type: ErrorType.missing,
        minValue: minAttackers,
        maxValue: maxValue,
        attackMode: attackMode,
      );
    } else if (attackers < minAttackers) {
      attackersError = FieldError(
        type: ErrorType.belowMinimum,
        minValue: minAttackers,
        maxValue: maxValue,
        attackMode: attackMode,
      );
    } else if (attackers > maxValue) {
      attackersError = FieldError(
        type: ErrorType.aboveMaximum,
        minValue: minAttackers,
        maxValue: maxValue,
        attackMode: attackMode,
      );
    }

    if (defenders == null) {
      defendersError = FieldError(
        type: ErrorType.missing,
        minValue: minValue,
        maxValue: maxValue,
        attackMode: attackMode,
      );
    } else if (defenders < minValue) {
      defendersError = FieldError(
        type: ErrorType.belowMinimum,
        minValue: minValue,
        maxValue: maxValue,
        attackMode: attackMode,
      );
    } else if (defenders > maxValue) {
      defendersError = FieldError(
        type: ErrorType.aboveMaximum,
        minValue: minValue,
        maxValue: maxValue,
        attackMode: attackMode,
      );
    }

    return ValidationResult(attackersError: attackersError, defendersError: defendersError);
  }
}
