import 'package:flutter/foundation.dart';
import '../validation/validation_result.dart';
import '../validation/validation_service.dart';

class BattleState extends ChangeNotifier {
  int? _attackers;
  int? _defenders;
  String _attackMode = 'allIn';
  ValidationResult _validationResult = ValidationResult.valid();

  int? get attackers => _attackers;
  int? get defenders => _defenders;
  String get attackMode => _attackMode;
  ValidationResult get validationResult => _validationResult;

  void setAttackers(int? value) {
    _attackers = value;
    _validate();
    notifyListeners();
  }

  void setDefenders(int? value) {
    _defenders = value;
    _validate();
    notifyListeners();
  }

  void setAttackMode(String mode) {
    _attackMode = mode;
    _validate();
    notifyListeners();
  }

  void _validate() {
    _validationResult = ValidationService.validate(
      attackers: _attackers,
      defenders: _defenders,
      attackMode: _attackMode,
    );
  }
}
