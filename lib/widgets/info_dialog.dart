import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
          Text(
            '1. Diese App arbeitet mit der Michelson\'schen Verzögerungstaktik.',
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: const [
                TextSpan(text: '2. Wenn sich '),
                TextSpan(
                  text: 'n',
                  style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ' Truppen auf dem angreifenden Land befinden, so hat der Angreifer nur '),
                TextSpan(
                  text: 'n-1',
                  style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ' angreifende Truppen, da eine Truppe auf dem Land bleiben muss.'),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Details zur Michelson\'schen Verzögerungstaktik und Hintergründe zur Berechnung stehen in folgendem Artikel:',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PdfViewerScreen()));
            },
            child: const Text('Artikel anzeigen'),
          ),
          const SizedBox(height: 32),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text('Diese App ist Open Source: ', style: Theme.of(context).textTheme.bodyMedium),
              GestureDetector(
                onTap: () async {
                  final url = Uri.parse('https://github.com/Peruno/Risiko');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
                child: Text(
                  'Quellcode',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
            ],
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
