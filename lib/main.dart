import 'package:flutter/material.dart';

void main() {
  runApp(const RisikoApp());
}

class RisikoApp extends StatelessWidget {
  const RisikoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Risiko Kampf Simulator',
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
  String _result = '';

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

    setState(() {
      _result = 'Simuliere Kampf: $attackers Angreifer gegen $defenders Verteidiger\n(Berechnungslogik wird implementiert)';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Risiko Kampf Simulator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                hintText: 'Anzahl der angreifenden Truppen eingeben',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _defendersController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Anzahl Verteidiger',
                border: OutlineInputBorder(),
                hintText: 'Anzahl der verteidigenden Truppen eingeben',
              ),
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
    );
  }

  @override
  void dispose() {
    _attackersController.dispose();
    _defendersController.dispose();
    super.dispose();
  }
}
