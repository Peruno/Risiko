class InputValidator {
  static const int minValue = 1;
  static const int maxValue = 128;

  final String attackersText;
  final String defendersText;
  final String? selectedAttackMode;

  InputValidator({required this.attackersText, required this.defendersText, this.selectedAttackMode});

  int? get attackers => int.tryParse(attackersText);
  int? get defenders => int.tryParse(defendersText);

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

  bool isFieldRedForInput(String text, bool isInvalid) {
    final value = int.tryParse(text) ?? 0;
    final exceedsMax = value > maxValue;

    return isInvalid || exceedsMax;
  }

  String? getSuffixTextForInput(String text, bool isInvalid, {bool isAttackerField = false}) {
    final value = int.tryParse(text) ?? 0;
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
      return 'Anzahl der Angreifer muss mindestens $minAttackersForMode sein';
    }

    if (attackers! > maxValue) {
      return 'Anzahl der Angreifer darf maximal $maxValue sein';
    }

    if (defenders == null || defenders! < minValue) {
      return 'Anzahl der Verteidiger muss mindestens $minValue sein';
    }

    if (defenders! > maxValue) {
      return 'Anzahl der Verteidiger darf maximal $maxValue sein';
    }

    return null;
  }
}
