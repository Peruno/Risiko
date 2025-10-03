import 'package:flutter/material.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Info', textAlign: TextAlign.center),
      content: const Text(
        'Diese App arbeitet mit der Michelson\'schen Verzögerungstaktik.',
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }

  static void show(BuildContext context) {
    showDialog(context: context, builder: (BuildContext context) => const InfoDialog());
  }
}
