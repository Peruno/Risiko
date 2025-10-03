class InputValidator {
  static const int minValue = 1;
  static const int maxValue = 128;

  final String attackersText;
  final String defendersText;
  final String? selectedAttackMode;

  InputValidator({
    required this.attackersText,
    required this.defendersText,
    this.selectedAttackMode,
  });

  int? get attackers => int.tryParse(attackersText);
  int? get defenders => int.tryParse(defendersText);

  bool get isAttackersNonNumeric => attackersText.isNotEmpty && attackers == null;
  bool get isDefendersNonNumeric => defendersText.isNotEmpty && defenders == null;

  bool isFieldRedForInput(String text, bool isInvalid) {
    final value = int.tryParse(text) ?? 0;
    final isNonNumeric = text.isNotEmpty && int.tryParse(text) == null;
    final exceedsMax = value > maxValue;

    return isInvalid || isNonNumeric || exceedsMax;
  }

  String? getSuffixTextForInput(String text, bool isInvalid) {
    final value = int.tryParse(text) ?? 0;
    final isNonNumeric = text.isNotEmpty && int.tryParse(text) == null;
    final exceedsMax = value > maxValue;

    if (exceedsMax) return 'max $maxValue';
    if (isInvalid) return 'min $minValue';
    if (isNonNumeric) return 'nur Zahlen';
    return null;
  }

  bool get isValid {
    if (attackers == null || defenders == null) return false;
    if (attackers! < minValue || attackers! > maxValue) return false;
    if (defenders! < minValue || defenders! > maxValue) return false;
    if (selectedAttackMode == 'safe' && attackers! < 3) return false;
    if (isAttackersNonNumeric || isDefendersNonNumeric) return false;
    return true;
  }

  String? validate() {
    if (isAttackersNonNumeric || isDefendersNonNumeric) {
      return null;
    }

    if (attackers == null || attackers! < minValue) {
      return 'Anzahl der Angreifer muss mindestens $minValue sein';
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

    if (selectedAttackMode == 'safe' && attackers! < 3) {
      return 'Sicherer Angriff benötigt mindestens 3 Angreifer';
    }

    return null;
  }
}
