import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../calculation/simulator.dart';
import '../../state/battle_state.dart';
import 'battle_distribution_chart.dart';
import 'utils/chart_data_transformer.dart';

class DetailedChartScreen extends StatefulWidget {
  const DetailedChartScreen({super.key});

  @override
  State<DetailedChartScreen> createState() => _DetailedChartScreenState();
}

class _DetailedChartScreenState extends State<DetailedChartScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BattleInputState>();
    final simulator = Simulator();
    final result = simulator.allIn(state.attackers!, state.defenders!, simulateOutcome: false);

    final attackerWinProbs = List.generate(state.attackers!, (i) => result.winProbabilities[i] ?? 0.0);
    final defenderWinProbs = List.generate(state.defenders!, (i) => result.lossProbabilities[i] ?? 0.0);

    final chartData = ChartDataTransformer.transform(
      attackerWinProbabilities: attackerWinProbs,
      defenderWinProbabilities: defenderWinProbs,
      totalWinProbability: result.overallWinProbability,
    );

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
      body: BattleDistributionChart(data: chartData),
    );
  }
}
