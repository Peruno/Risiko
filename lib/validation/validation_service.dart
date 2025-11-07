import 'validation_result.dart';

class ValidationService {
  static const int minValue = 1;
  static const int maxValue = 128;

  static ValidationResult validate({required int? attackers, required int? defenders, required String attackMode}) {
    final minAttackers = attackMode == 'safe' ? 3 : minValue;

    FieldError? attackersError;
    FieldError? defendersError;

    if (attackers == null) {
      attackersError = FieldError(
        type: ErrorType.missing,
        value: null,
        minValue: minAttackers,
        maxValue: maxValue,
        attackMode: attackMode,
      );
    } else if (attackers < minAttackers) {
      attackersError = FieldError(
        type: ErrorType.belowMinimum,
        value: attackers,
        minValue: minAttackers,
        maxValue: maxValue,
        attackMode: attackMode,
      );
    } else if (attackers > maxValue) {
      attackersError = FieldError(
        type: ErrorType.aboveMaximum,
        value: attackers,
        minValue: minAttackers,
        maxValue: maxValue,
        attackMode: attackMode,
      );
    }

    if (defenders == null) {
      defendersError = FieldError(
        type: ErrorType.missing,
        value: null,
        minValue: minValue,
        maxValue: maxValue,
        attackMode: attackMode,
      );
    } else if (defenders < minValue) {
      defendersError = FieldError(
        type: ErrorType.belowMinimum,
        value: defenders,
        minValue: minValue,
        maxValue: maxValue,
        attackMode: attackMode,
      );
    } else if (defenders > maxValue) {
      defendersError = FieldError(
        type: ErrorType.aboveMaximum,
        value: defenders,
        minValue: minValue,
        maxValue: maxValue,
        attackMode: attackMode,
      );
    }

    return ValidationResult(attackersError: attackersError, defendersError: defendersError);
  }
}
