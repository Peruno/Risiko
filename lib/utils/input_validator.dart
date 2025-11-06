class InputValidator {
  static const int minValue = 1;
  static const int maxValue = 128;

  final int? attackers;
  final int? defenders;
  final String? selectedAttackMode;

  InputValidator({required this.attackers, required this.defenders, this.selectedAttackMode});

  int get minAttackersForMode => selectedAttackMode == 'safe' ? 3 : minValue;

  bool get isAttackersInvalid {
    if (attackers == null) return false;
    if (attackers! < minAttackersForMode || attackers! > maxValue) return true;
    return false;
  }

  bool get isDefendersInvalid {
    if (defenders == null) return false;
    if (defenders! < minValue || defenders! > maxValue) return true;
    return false;
  }

  bool isFieldRedForInput(bool isInvalid, int? value) {
    if (value == null) return false;
    final exceedsMax = value > maxValue;
    return isInvalid || exceedsMax;
  }

  String? getSuffixTextForInput(bool isInvalid, int? value, {bool isAttackerField = false}) {
    if (value == null) return null;
    final exceedsMax = value > maxValue;
    final effectiveMin = isAttackerField ? minAttackersForMode : minValue;

    if (exceedsMax) return 'max $maxValue';
    if (isInvalid) return 'min $effectiveMin';
    return null;
  }

  bool get isValid {
    if (attackers == null || defenders == null) return false;
    if (attackers! < minAttackersForMode || attackers! > maxValue) return false;
    if (defenders! < minValue || defenders! > maxValue) return false;
    return true;
  }

  String? validate() {
    if (attackers == null || attackers! < minAttackersForMode) {
      return 'Die Anzahl der Angreifer muss mindestens $minAttackersForMode sein.';
    }

    if (attackers! > maxValue) {
      return 'Die Anzahl der Angreifer darf maximal $maxValue sein.';
    }

    if (defenders == null || defenders! < minValue) {
      return 'Die Anzahl der Verteidiger muss mindestens $minValue sein.';
    }

    if (defenders! > maxValue) {
      return 'Die Anzahl der Verteidiger darf maximal $maxValue sein.';
    }

    return null;
  }
}
