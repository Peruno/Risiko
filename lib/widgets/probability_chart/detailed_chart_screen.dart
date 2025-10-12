import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:risiko_simulator/widgets/probability_chart/probability_chart.dart';

class DetailedChartScreen extends StatefulWidget {
  final List<double> attackerWinProbabilities;
  final List<double> defenderWinProbabilities;
  final int attackers;
  final int defenders;
  final double totalWinProbability;

  const DetailedChartScreen({
    super.key,
    required this.attackerWinProbabilities,
    required this.defenderWinProbabilities,
    required this.attackers,
    required this.defenders,
    required this.totalWinProbability,
  });

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.attackers} Angreifer gegen ${widget.defenders} Verteidiger',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ProbabilityChart(
        attackerWinProbabilities: widget.attackerWinProbabilities,
        defenderWinProbabilities: widget.defenderWinProbabilities,
        attackers: widget.attackers,
        defenders: widget.defenders,
        totalWinProbability: widget.totalWinProbability,
      ),
    );
  }
}
