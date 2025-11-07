import 'package:flutter/foundation.dart';
import '../validation/validation_result.dart';
import '../validation/validation_service.dart';

class BattleState extends ChangeNotifier {
  int? _attackers;
  int? _defenders;
  String _attackMode = 'allIn';
  late ValidationResult _validationResult;
  bool _attackersTouched = false;
  bool _defendersTouched = false;
  bool _forceShowErrors = false;

  BattleState() {
    _validate();
  }

  int? get attackers => _attackers;
  int? get defenders => _defenders;
  String get attackMode => _attackMode;
  ValidationResult get validationResult => _validationResult;
  bool get attackersTouched => _attackersTouched;
  bool get defendersTouched => _defendersTouched;
  bool get shouldShowErrors => _forceShowErrors;

  void setAttackers(int? value) {
    _attackers = value;
    _attackersTouched = true;
    _validate();
    notifyListeners();
  }

  void setDefenders(int? value) {
    _defenders = value;
    _defendersTouched = true;
    _validate();
    notifyListeners();
  }

  void setAttackMode(String mode) {
    _attackMode = mode;
    _validate();
    notifyListeners();
  }

  void forceShowErrors() {
    _forceShowErrors = true;
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
