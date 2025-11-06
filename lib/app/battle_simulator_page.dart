import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../calculation/simulator.dart';
import '../state/battle_state.dart';
import '../utils/battle_result_formatter.dart';
import '../validation/validation_message_formatter.dart';
import '../widgets/attack_mode_selector.dart';
import '../widgets/probability_chart/detailed_chart_screen.dart';
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

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BattleState>();
    final errorBoxText = ValidationMessageFormatter.getErrorBoxText(state.validationResult);

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAttackerInputField(),
              const SizedBox(height: 16),
              _buildDefenderInputField(),
              const SizedBox(height: 24),
              _buildAttackModeSelector(),
              const SizedBox(height: 24),
              buildCalculateProbabilitiesButton(),
              const SizedBox(height: 12),
              _buildDetailedDiagramButton(),
              const SizedBox(height: 12),
              _buildShowResultButton(),
              const SizedBox(height: 24),
              if (errorBoxText != null) _buildResultBox(errorBoxText),
              if (_result.isNotEmpty && errorBoxText == null) _buildResultBox(_result),
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

  Container _buildResultBox(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
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
    final state = context.read<BattleState>();
    return AttackModeSelector(
      selectedAttackMode: state.attackMode,
      onModeSelected: (mode) {
        context.read<BattleState>().setAttackMode(mode);
      },
      onTap: _dismissKeyboard,
    );
  }

  ValidatedNumberField _buildDefenderInputField() {
    return ValidatedNumberField(
      key: const Key('defender_field'),
      controller: _defendersController,
      label: 'Anzahl Verteidiger',
    );
  }

  ValidatedNumberField _buildAttackerInputField() {
    return ValidatedNumberField(
      key: const Key('attacker_field'),
      controller: _attackersController,
      label: 'Anzahl Angreifer',
      isAttackerField: true,
    );
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _calculateProbabilities() {
    _dismissKeyboard();
    final state = context.read<BattleState>();

    if (!state.validationResult.isValid) {
      return;
    }

    final BattleResult result = state.attackMode == 'safe'
        ? _simulator.safeAttack(state.attackers!, state.defenders!, simulateOutcome: false)
        : _simulator.allIn(state.attackers!, state.defenders!, simulateOutcome: false);

    final formatter = BattleResultFormatter(result: result, selectedAttackMode: state.attackMode);
    setState(() {
      _result = formatter.formatProbabilities();
    });
  }

  void _simulateBattle() {
    _dismissKeyboard();
    final state = context.read<BattleState>();

    if (!state.validationResult.isValid) {
      return;
    }

    final BattleResult result;
    if (state.attackMode == 'safe') {
      result = _simulator.safeAttack(state.attackers!, state.defenders!, simulateOutcome: true);
    } else {
      result = _simulator.allIn(state.attackers!, state.defenders!, simulateOutcome: true);
    }

    final formatter = BattleResultFormatter(result: result, selectedAttackMode: state.attackMode);
    setState(() {
      _result = formatter.formatBattleOutcome();
    });
  }

  void _showDetailedChart() {
    _dismissKeyboard();
    final state = context.read<BattleState>();

    if (!state.validationResult.isValid) {
      return;
    }

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DetailedChartScreen()));
  }

  @override
  void dispose() {
    _attackersController.dispose();
    _defendersController.dispose();
    super.dispose();
  }
}
