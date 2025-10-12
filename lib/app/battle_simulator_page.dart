import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../calculation/simulator.dart';
import '../utils/battle_result_formatter.dart';
import '../utils/input_validator.dart';
import '../widgets/attack_mode_selector.dart';
import '../widgets/detailed_chart_screen.dart';
import '../widgets/info_dialog.dart';
import '../widgets/validated_number_field.dart';

class BattleSimulatorPage extends StatefulWidget {
  const BattleSimulatorPage({super.key});

  @override
  State<BattleSimulatorPage> createState() => _BattleSimulatorPageState();
}

class _BattleSimulatorPageState extends State<BattleSimulatorPage> {
  final TextEditingController _attackersController = TextEditingController();
  final TextEditingController _defendersController = TextEditingController();
  final Simulator _simulator = Simulator();
  String _result = '';
  bool _attackersInvalid = false;
  bool _defendersInvalid = false;
  String? _selectedAttackMode = 'allIn';

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    _attackersController.addListener(_validateInput);
    _defendersController.addListener(_validateInput);
  }

  @override
  Widget build(BuildContext context) {
    final validator = InputValidator(
      attackersText: _attackersController.text,
      defendersText: _defendersController.text,
      selectedAttackMode: _selectedAttackMode,
    );

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAttackerInputField(validator),
              const SizedBox(height: 16),
              _buildDefenderInputField(validator),
              const SizedBox(height: 24),
              _buildAttackModeSelector(),
              const SizedBox(height: 24),
              buildCalculateProbabilitiesButton(),
              const SizedBox(height: 12),
              _buildDetailedDiagramButton(),
              const SizedBox(height: 12),
              _buildShowResultButton(),
              const SizedBox(height: 24),
              if (_result.isNotEmpty) _buildResultBox(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: const Text('Risiko Simulator'),
      actions: [
        IconButton(
          onPressed: () => InfoDialog.show(context),
          icon: const Icon(Icons.info_outline),
          tooltip: 'Information',
        ),
      ],
    );
  }

  Container _buildResultBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(_result, style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
    );
  }

  ElevatedButton _buildShowResultButton() {
    return ElevatedButton(
      onPressed: _simulateBattle,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      child: const Text('Ergebnis simulieren', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  ElevatedButton _buildDetailedDiagramButton() {
    return ElevatedButton(
      onPressed: _showDetailedChart,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      child: const Text('Detailliertes Diagramm', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  ElevatedButton buildCalculateProbabilitiesButton() {
    return ElevatedButton(
      onPressed: _calculateProbabilities,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      child: const Text('Chancen berechnen', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  AttackModeSelector _buildAttackModeSelector() {
    return AttackModeSelector(
      selectedAttackMode: _selectedAttackMode,
      onModeSelected: (mode) {
        setState(() {
          _selectedAttackMode = mode;
        });
        _validateInput();
      },
      onTap: _dismissKeyboard,
    );
  }

  ValidatedNumberField _buildDefenderInputField(InputValidator validator) {
    return ValidatedNumberField(
      controller: _defendersController,
      label: 'Anzahl Verteidiger',
      isInvalid: _defendersInvalid,
      validator: validator,
    );
  }

  ValidatedNumberField _buildAttackerInputField(InputValidator validator) {
    return ValidatedNumberField(
      controller: _attackersController,
      label: 'Anzahl Angreifer',
      isInvalid: _attackersInvalid,
      validator: validator,
      isAttackerField: true,
    );
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _validateInput() {
    final validator = InputValidator(
      attackersText: _attackersController.text,
      defendersText: _defendersController.text,
      selectedAttackMode: _selectedAttackMode,
    );

    setState(() {
      final validationError = validator.validate();
      if (validationError != null) {
        _result = validationError;
        _attackersInvalid = validator.isAttackersInvalid;
        _defendersInvalid = validator.isDefendersInvalid;
      } else {
        _result = '';
        _attackersInvalid = false;
        _defendersInvalid = false;
      }
    });
  }

  void _calculateProbabilities() {
    _dismissKeyboard();
    final validator = InputValidator(
      attackersText: _attackersController.text,
      defendersText: _defendersController.text,
      selectedAttackMode: _selectedAttackMode,
    );

    final validationError = validator.validate();
    if (validationError != null) {
      setState(() {
        _result = validationError;
        _attackersInvalid = validationError.contains('Angreifer');
        _defendersInvalid = validationError.contains('Verteidiger');
      });
      return;
    }

    try {
      final BattleResult result = _selectedAttackMode == 'safe'
          ? _simulator.safeAttack(validator.attackers!, validator.defenders!, simulateOutcome: false)
          : _simulator.allIn(validator.attackers!, validator.defenders!, simulateOutcome: false);

      final formatter = BattleResultFormatter(result: result, selectedAttackMode: _selectedAttackMode);
      setState(() {
        _result = formatter.formatProbabilities();
        _attackersInvalid = false;
        _defendersInvalid = false;
      });
    } catch (e) {
      setState(() {
        _result = 'Fehler bei der Berechnung: $e';
      });
    }
  }

  void _simulateBattle() {
    _dismissKeyboard();
    final validator = InputValidator(
      attackersText: _attackersController.text,
      defendersText: _defendersController.text,
      selectedAttackMode: _selectedAttackMode,
    );

    final validationError = validator.validate();
    if (validationError != null) {
      setState(() {
        _result = validationError;
        _attackersInvalid = validationError.contains('Angreifer');
        _defendersInvalid = validationError.contains('Verteidiger');
      });
      return;
    }

    try {
      final BattleResult result;
      if (_selectedAttackMode == 'safe') {
        result = _simulator.safeAttack(validator.attackers!, validator.defenders!, simulateOutcome: true);
      } else {
        result = _simulator.allIn(validator.attackers!, validator.defenders!, simulateOutcome: true);
      }

      final formatter = BattleResultFormatter(result: result, selectedAttackMode: _selectedAttackMode);
      setState(() {
        _result = formatter.formatBattleOutcome();
        _attackersInvalid = false;
        _defendersInvalid = false;
      });
    } catch (e) {
      setState(() {
        _result = 'Fehler bei der Berechnung: $e';
      });
    }
  }

  void _showDetailedChart() {
    _dismissKeyboard();
    final validator = InputValidator(
      attackersText: _attackersController.text,
      defendersText: _defendersController.text,
      selectedAttackMode: _selectedAttackMode,
    );

    final validationError = validator.validate();
    if (validationError != null) {
      setState(() {
        _result = validationError;
      });
      return;
    }

    try {
      final BattleResult result;
      result = _simulator.allIn(validator.attackers!, validator.defenders!, simulateOutcome: false);

      List<double> attackerWinProbs = [];
      List<double> defenderWinProbs = [];

      for (int i = 0; i < validator.attackers!; i++) {
        attackerWinProbs.add(result.winProbabilities[i] ?? 0.0);
      }

      for (int i = 0; i < validator.defenders!; i++) {
        defenderWinProbs.add(result.lossProbabilities[i] ?? 0.0);
      }

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DetailedChartScreen(
            attackerWinProbabilities: attackerWinProbs,
            defenderWinProbabilities: defenderWinProbs,
            attackers: validator.attackers!,
            defenders: validator.defenders!,
            totalWinProbability: result.winProbability,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _result = 'Fehler bei der Berechnung: $e';
      });
    }
  }

  @override
  void dispose() {
    _attackersController.dispose();
    _defendersController.dispose();
    super.dispose();
  }
}
