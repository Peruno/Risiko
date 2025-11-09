import 'package:flutter/foundation.dart';
import '../validation/validation_result.dart';
import '../validation/validation_service.dart';

enum AttackMode { allIn, safe }

class BattleState extends ChangeNotifier {
  int? _attackers;
  int? _defenders;
  AttackMode _attackMode = AttackMode.allIn;
  late ValidationResult _validationResult;
  bool _isAttackersTouched = false;
  bool _isDefendersTouched = false;
  bool _shouldShowErrors = false;

  BattleState() {
    _validate();
  }

  int? get attackers => _attackers;
  int? get defenders => _defenders;
  AttackMode get attackMode => _attackMode;
  ValidationResult get validationResult => _validationResult;
  bool get attackersTouched => _isAttackersTouched;
  bool get defendersTouched => _isDefendersTouched;
  bool get shouldShowErrors => _shouldShowErrors;

  void setAttackers(int? value) {
    _attackers = value;
    _isAttackersTouched = true;
    _validate();
    notifyListeners();
  }

  void setDefenders(int? value) {
    _defenders = value;
    _isDefendersTouched = true;
    _validate();
    notifyListeners();
  }

  void setAttackMode(AttackMode mode) {
    _attackMode = mode;
    _validate();
    notifyListeners();
  }

  void forceShowErrors() {
    _shouldShowErrors = true;
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
