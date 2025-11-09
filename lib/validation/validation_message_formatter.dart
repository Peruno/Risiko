import '../state/battle_state.dart';
import 'validation_result.dart';

class ValidationMessageFormatter {
  static String? getSuffixText(FieldError? error) {
    if (error == null) return null;

    switch (error.type) {
      case ErrorType.missing:
        return 'min ${error.minValue}';
      case ErrorType.belowMinimum:
        return 'min ${error.minValue}';
      case ErrorType.aboveMaximum:
        return 'max ${error.maxValue}';
    }
  }

  static String? getErrorBoxText(ValidationResult result) {
    if (result.isValid) return null;

    if (result.attackersError != null) {
      final error = result.attackersError!;
      switch (error.type) {
        case ErrorType.missing:
          if (error.attackMode == AttackMode.safe) {
            return 'Die Anzahl der Angreifer muss bei einem sicheren Angriff mindestens ${error.minValue} sein.';
          } else {
            return 'Die Anzahl der Angreifer muss mindestens ${error.minValue} sein.';
          }
        case ErrorType.belowMinimum:
          if (error.attackMode == AttackMode.safe) {
            return 'Die Anzahl der Angreifer muss bei einem sicheren Angriff mindestens ${error.minValue} sein.';
          } else {
            return 'Die Anzahl der Angreifer muss mindestens ${error.minValue} sein.';
          }
        case ErrorType.aboveMaximum:
          return 'Die Anzahl der Angreifer darf maximal ${error.maxValue} sein.';
      }
    }

    if (result.defendersError != null) {
      final error = result.defendersError!;
      switch (error.type) {
        case ErrorType.missing:
          return 'Die Anzahl der Verteidiger muss mindestens ${error.minValue} sein.';
        case ErrorType.belowMinimum:
          return 'Die Anzahl der Verteidiger muss mindestens ${error.minValue} sein.';
        case ErrorType.aboveMaximum:
          return 'Die Anzahl der Verteidiger darf maximal ${error.maxValue} sein.';
      }
    }

    return null;
  }
}
