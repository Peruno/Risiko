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
  bool _attackersExceedsMax = false;
  bool _defendersExceedsMax = false;

  @override
  void initState() {
    super.initState();
    _attackersController.addListener(_validateInput);
    _defendersController.addListener(_validateInput);
  }

  void _validateInput() {
    final int attackers = int.tryParse(_attackersController.text) ?? 0;
    final int defenders = int.tryParse(_defendersController.text) ?? 0;
    
    setState(() {
      _attackersExceedsMax = attackers > 128;
      _defendersExceedsMax = defenders > 128;
    });
  }

  void _calculateProbabilities() {
    final int attackers = int.tryParse(_attackersController.text) ?? 0;
    final int defenders = int.tryParse(_defendersController.text) ?? 0;
    
    if (attackers < 1) {
      setState(() {
        _result = 'Anzahl der Angreifer muss mindestens 1 sein';
      });
      return;
    }

    if (attackers > 128) {
      setState(() {
        _result = 'Anzahl der Angreifer darf maximal 128 sein';
      });
      return;
    }

    if (defenders < 1) {
      setState(() {
        _result = 'Anzahl der Verteidiger muss mindestens 1 sein';
      });
      return;
    }

    if (defenders > 128) {
      setState(() {
        _result = 'Anzahl der Verteidiger darf maximal 128 sein';
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
        result = _simulator.safeAttack(attackers, defenders, simulateOutcome: false);
      } else {
        result = _simulator.allIn(attackers, defenders, simulateOutcome: false);
      }

      setState(() {
        _result = _formatProbabilities(result);
      });
    } catch (e) {
      setState(() {
        if (e.toString().contains('defenders') || e.toString().contains('Verteidiger')) {
          _result = 'Anzahl der Verteidiger muss mindestens 1 sein';
        } else if (e.toString().contains('attackers') || e.toString().contains('Angreifer')) {
          _result = 'Anzahl der Angreifer muss mindestens 1 sein';
        } else {
          _result = 'Fehler bei der Berechnung: $e';
        }
      });
    }
  }

  void _simulateBattle() {
    final int attackers = int.tryParse(_attackersController.text) ?? 0;
    final int defenders = int.tryParse(_defendersController.text) ?? 0;
    
    if (attackers < 1) {
      setState(() {
        _result = 'Anzahl der Angreifer muss mindestens 1 sein';
      });
      return;
    }
    
    if (attackers > 128) {
      setState(() {
        _result = 'Anzahl der Angreifer darf maximal 128 sein';
      });
      return;
    }
    
    if (defenders < 1) {
      setState(() {
        _result = 'Anzahl der Verteidiger muss mindestens 1 sein';
      });
      return;
    }
    
    if (defenders > 128) {
      setState(() {
        _result = 'Anzahl der Verteidiger darf maximal 128 sein';
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

  String _formatProbabilities(BattleResult result) {
    final buffer = StringBuffer();
    
    buffer.writeln('Angreifer gewinnt: ${(result.winProbability * 100).toStringAsFixed(1)}%');
    if (_safeAttackMode) {
      final retreatProb = result.lossProbabilities.values.reduce((a, b) => a + b);
      buffer.writeln('Rückzug: ${(retreatProb * 100).toStringAsFixed(1)}%');
    } else {
      buffer.writeln('Verteidiger gewinnt: ${((1 - result.winProbability) * 100).toStringAsFixed(1)}%');
    }

    return buffer.toString();
  }

  String _formatBattleResult(int attackers, int defenders, BattleResult result) {
    final buffer = StringBuffer();
    
    buffer.write(_formatProbabilities(result));
    buffer.writeln('');
    
    switch (result.outcome) {
      case BattleOutcome.victory:
        buffer.writeln('🟢 SIEG DES ANGREIFERS!');
        buffer.writeln('Verluste des Angreifers: ${result.losses}');
        break;
      case BattleOutcome.defeat:
        buffer.writeln('🔴 SIEG DES VERTEIDIGERS!');
        buffer.writeln('Verluste des Verteidigers: ${result.losses}');
        buffer.writeln('Verbleibende Verteidiger: ${defenders - result.losses}');
        break;
      case BattleOutcome.retreat:
        buffer.writeln('🟡 RÜCKZUG DES ANGREIFERS!');
        buffer.writeln('Verluste des Verteidigers: ${result.losses}');
        break;
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
            TextField(
              controller: _attackersController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Anzahl Angreifer',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _attackersExceedsMax ? Colors.red : Colors.grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _attackersExceedsMax ? Colors.red : Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _attackersExceedsMax ? Colors.red : Colors.blue,
                  ),
                ),
                hintText: 'Anzahl der angreifenden Truppen',
                counterText: '',
                labelStyle: TextStyle(
                  color: _attackersExceedsMax ? Colors.red : null,
                ),
                suffixText: _attackersExceedsMax ? 'max 128' : null,
                suffixStyle: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _defendersController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Anzahl Verteidiger',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _defendersExceedsMax ? Colors.red : Colors.grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _defendersExceedsMax ? Colors.red : Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _defendersExceedsMax ? Colors.red : Colors.blue,
                  ),
                ),
                hintText: 'Anzahl der verteidigenden Truppen',
                counterText: '',
                labelStyle: TextStyle(
                  color: _defendersExceedsMax ? Colors.red : null,
                ),
                suffixText: _defendersExceedsMax ? 'max 128' : null,
                suffixStyle: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 60,
                        child: Text(
                          'All In',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: _safeAttackMode ? FontWeight.normal : FontWeight.bold,
                            color: _safeAttackMode ? Colors.grey : Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Switch(
                        value: _safeAttackMode,
                        onChanged: (bool value) {
                          setState(() {
                            _safeAttackMode = value;
                          });
                        },
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 120,
                        child: Text(
                          'Sicherer Angriff',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: _safeAttackMode ? FontWeight.bold : FontWeight.normal,
                            color: _safeAttackMode ? Colors.black : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 16,
                    child: Text(
                      _safeAttackMode 
                          ? '(Rückzug bei 2 verbleibenden Angreifern)'
                          : '(Kampf bis zum letzten Mann)',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _calculateProbabilities,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Chancen berechnen',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _simulateBattle,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Schlacht starten',
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
                  textAlign: TextAlign.center,
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
