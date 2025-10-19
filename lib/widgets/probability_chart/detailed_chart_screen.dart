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
                '${widget.attackers} Angreifer gegen ${widget.defenders} Verteidiger',
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
        attackerWinProbabilities: widget.attackerWinProbabilities,
        defenderWinProbabilities: widget.defenderWinProbabilities,
        attackers: widget.attackers,
        defenders: widget.defenders,
        totalWinProbability: widget.totalWinProbability,
      ),
    );
  }
}
