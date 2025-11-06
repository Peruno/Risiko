enum ErrorType { belowMinimum, aboveMaximum }

class FieldError {
  final ErrorType type;
  final int value;
  final int minValue;
  final int maxValue;
  final String attackMode;

  const FieldError({
    required this.type,
    required this.value,
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

  factory ValidationResult.valid() => const ValidationResult();
}
