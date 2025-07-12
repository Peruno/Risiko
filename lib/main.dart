import 'package:flutter/material.dart';
import 'models/simulator.dart';

void main() {
  runApp(const RisikoApp());
}

class RisikoApp extends StatelessWidget {
  const RisikoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Risiko Simulator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const BattleSimulatorPage(),
    );
  }
}

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
  bool _safeAttackMode = false;

  void _simulateBattle() {
    final int attackers = int.tryParse(_attackersController.text) ?? 0;
    final int defenders = int.tryParse(_defendersController.text) ?? 0;
    
    if (attackers < 1) {
      setState(() {
        _result = 'Anzahl der Angreifer muss mindestens 1 sein';
      });
      return;
    }
    
    if (defenders < 1) {
      setState(() {
        _result = 'Anzahl der Verteidiger muss mindestens 1 sein';
      });
      return;
    }

    if (_safeAttackMode && attackers < 3) {
      setState(() {
        _result = 'Sicherer Angriff benötigt mindestens 3 Angreifer';
      });
      return;
    }

    try {
      final BattleResult result;
      if (_safeAttackMode) {
        result = _simulator.safeAttack(attackers, defenders, simulateOutcome: true);
      } else {
        result = _simulator.allIn(attackers, defenders, simulateOutcome: true);
      }

      setState(() {
        _result = _formatBattleResult(attackers, defenders, result);
      });
    } catch (e) {
      setState(() {
        _result = 'Fehler bei der Berechnung: $e';
      });
    }
  }

  String _formatBattleResult(int attackers, int defenders, BattleResult result) {
    final buffer = StringBuffer();
    
    buffer.writeln('🎲 KAMPF SIMULIERT 🎲');
    buffer.writeln('');
    buffer.writeln('$attackers Angreifer vs $defenders Verteidiger');
    if (_safeAttackMode) {
      buffer.writeln('(Sicherer Angriff - stoppt bei 2 Angreifern)');
    }
    buffer.writeln('');
    
    buffer.writeln('📊 ERGEBNIS:');
    switch (result.outcome) {
      case BattleOutcome.victory:
        buffer.writeln('🟢 SIEG DES ANGREIFERS!');
        buffer.writeln('Verluste des Angreifers: ${result.losses}');
        buffer.writeln('Verbleibende Angreifer: ${attackers - result.losses}');
        break;
      case BattleOutcome.defeat:
        buffer.writeln('🔴 SIEG DES VERTEIDIGERS!');
        buffer.writeln('Verluste des Verteidigers: ${result.losses}');
        buffer.writeln('Verbleibende Verteidiger: ${defenders - result.losses}');
        break;
      case BattleOutcome.retreat:
        buffer.writeln('🟡 RÜCKZUG DES ANGREIFERS!');
        buffer.writeln('Angreifer stoppt bei 2 Truppen');
        buffer.writeln('Verluste des Verteidigers: ${result.losses}');
        buffer.writeln('Verbleibende Verteidiger: ${defenders - result.losses}');
        break;
    }
    
    buffer.writeln('');
    buffer.writeln('📈 WAHRSCHEINLICHKEITEN:');
    buffer.writeln('Siegchance Angreifer: ${(result.winProbability * 100).toStringAsFixed(1)}%');
    if (_safeAttackMode) {
      final retreatProb = result.lossProbabilities.values.reduce((a, b) => a + b);
      buffer.writeln('Rückzugschance: ${(retreatProb * 100).toStringAsFixed(1)}%');
    } else {
      buffer.writeln('Siegchance Verteidiger: ${((1 - result.winProbability) * 100).toStringAsFixed(1)}%');
    }

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Risiko Simulator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            const Text(
              'Kampfparameter eingeben',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _attackersController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Anzahl Angreifer',
                border: OutlineInputBorder(),
                hintText: 'Anzahl der angreifenden Truppen',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _defendersController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Anzahl Verteidiger',
                border: OutlineInputBorder(),
                hintText: 'Anzahl der verteidigenden Truppen',
              ),
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              title: const Text('Sicherer Angriff'),
              subtitle: const Text('Stoppt bei 2 verbleibenden Angreifern'),
              value: _safeAttackMode,
              onChanged: (bool value) {
                setState(() {
                  _safeAttackMode = value;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _simulateBattle,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'LOS',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            if (_result.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _result,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _attackersController.dispose();
    _defendersController.dispose();
    super.dispose();
  }
}
