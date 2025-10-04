import 'package:flutter/material.dart';
import 'pdf_viewer_screen.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Info', textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Diese App arbeitet mit der Michelson\'schen Verzögerungstaktik.', textAlign: TextAlign.center),
          const SizedBox(height: 16),
          const Text(
            'Hier ist ein Artikel mit einer detaillierten Erklärung zur Würfeltaktik und ein paar Hintergründen zur Berechnung. Ich habe ihn vor ein paar Jahren einmal firmenintern veröffentlicht und er ist hier quasi unverändert wiedergegeben.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PdfViewerScreen()));
            },
            child: const Text('Artikel anzeigen'),
          ),
        ],
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
