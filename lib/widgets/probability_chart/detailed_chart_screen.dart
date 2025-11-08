import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:risiko_simulator/calculation/simulator.dart';
import 'package:risiko_simulator/state/battle_state.dart';
import 'package:risiko_simulator/widgets/probability_chart/probability_chart.dart';

class DetailedChartScreen extends StatefulWidget {
  const DetailedChartScreen({super.key});

  @override
  State<DetailedChartScreen> createState() => _DetailedChartScreenState();
}

class _DetailedChartScreenState extends State<DetailedChartScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BattleState>();
    final simulator = Simulator();
    final result = simulator.allIn(state.attackers!, state.defenders!, simulateOutcome: false);

    List<double> attackerWinProbs = [];
    List<double> defenderWinProbs = [];

    for (int i = 0; i < state.attackers!; i++) {
      attackerWinProbs.add(result.winProbabilities[i] ?? 0.0);
    }

    for (int i = 0; i < state.defenders!; i++) {
      defenderWinProbs.add(result.lossProbabilities[i] ?? 0.0);
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final toolbarHeight = screenHeight * 0.10;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: toolbarHeight,
        centerTitle: true,
        title: Text(
          '${state.attackers} Angreifer gegen ${state.defenders} Verteidiger',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.black),
        ),
        leading: const BackButton(color: Colors.black),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ProbabilityChart(
        attackerWinProbabilities: attackerWinProbs,
        defenderWinProbabilities: defenderWinProbs,
        attackers: state.attackers!,
        defenders: state.defenders!,
        totalWinProbability: result.winProbability,
      ),
    );
  }
}
