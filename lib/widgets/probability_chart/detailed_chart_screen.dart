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

    const double appBarHeight = 24.0;
    const double backButtonSize = 48.0;
    const double backButtonVisualAdjustment = 4.0;
    final double backButtonOffset = (appBarHeight - backButtonSize) / 2 - backButtonVisualAdjustment;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
          clipBehavior: Clip.none,
          centerTitle: true,
          titleSpacing: 0,
          flexibleSpace: Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Center(
              child: Text(
                '${state.attackers} Angreifer gegen ${state.defenders} Verteidiger',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.black),
              ),
            ),
          ),
          leading: Transform.translate(
            offset: Offset(0, backButtonOffset),
            child: BackButton(color: Colors.black),
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
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
