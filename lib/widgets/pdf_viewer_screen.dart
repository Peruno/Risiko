import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdfx/pdfx.dart';

class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({super.key});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late Future<PdfDocument> _document;

  @override
  void initState() {
    super.initState();
    _document = PdfDocument.openAsset('docs/latex/output/main.pdf');
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Artikel'), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: FutureBuilder<PdfDocument>(
        future: _document,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildPdfView(snapshot.data!);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildPdfView(PdfDocument document) {
    final pageCount = document.pagesCount;
    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 4.0,
      child: ListView.builder(itemCount: pageCount, itemBuilder: (context, index) => _buildPage(document, index + 1)),
    );
  }

  Widget _buildPage(PdfDocument document, int pageNumber) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final screenWidth = MediaQuery.of(context).size.width;
    final renderScale = 2.5;

    return FutureBuilder<PdfPageImage>(
      future: _renderHighResPage(document, pageNumber, devicePixelRatio, screenWidth, renderScale),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final image = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Image.memory(image.bytes, fit: BoxFit.contain),
          );
        }
        return const SizedBox(height: 800, child: Center(child: CircularProgressIndicator()));
      },
    );
  }

  Future<PdfPageImage> _renderHighResPage(
    PdfDocument document,
    int pageNumber,
    double devicePixelRatio,
    double screenWidth,
    double renderScale,
  ) async {
    final page = await document.getPage(pageNumber);
    final renderWidth = screenWidth * devicePixelRatio * renderScale;
    final renderHeight = (page.height / page.width) * renderWidth;
    final image = await page.render(width: renderWidth, height: renderHeight, format: PdfPageImageFormat.png);
    await page.close();
    return image!;
  }
}
