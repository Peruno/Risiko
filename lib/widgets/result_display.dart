import 'package:flutter/material.dart';

class ResultDisplay extends StatefulWidget {
  const ResultDisplay({super.key});

  @override
  State<ResultDisplay> createState() => ResultDisplayState();
}

class ResultDisplayState extends State<ResultDisplay> {
  String _result = '';

  void showResult(String result) {
    setState(() {
      _result = result;
    });
  }

  void clear() {
    setState(() {
      _result = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_result.isEmpty) return const SizedBox.shrink();

    return Container(
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
    );
  }
}
