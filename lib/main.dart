import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf_viewer_example/api/pdf_api.dart';
import 'package:pdf_viewer_example/page/pdf_viewer_page.dart';
import 'package:pdf_viewer_example/widget/button_widget.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'PDF Viewer';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(
          primaryColor: Colors.blue,
        ),
        home: MainPage(),
      );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonWidget(
                  text: 'Asset PDF',
                  onClicked: () async {
                    final path = 'assets/sample.pdf';
                    final file = await PDFApi.loadAsset(path);
                    openPDF(context, file);
                  },
                ),
                const SizedBox(height: 16),
                ButtonWidget(
                  text: 'File PDF',
                  onClicked: () async {
                    final file = await PDFApi.pickFile();

                    if (file == null) return;
                    openPDF(context, file);
                  },
                ),
                const SizedBox(height: 16),
                ButtonWidget(
                  text: 'Network PDF',
                  onClicked: () async {
                    final url =
                        'https://www.adobe.com/support/products/enterprise/knowledgecenter/media/c4611_sample_explain.pdf';
                    final file = await PDFApi.loadNetwork(url);
                    openPDF(context, file);
                  },
                ),
                const SizedBox(height: 16),
                ButtonWidget(
                  text: 'Firebase PDF',
                  onClicked: () async {
                    final url = 'sample.pdf';
                    final file = await PDFApi.loadFirebase(url);

                    if (file == null) return;
                    openPDF(context, file);
                  },
                ),
              ],
            ),
          ),
        ),
      );

  void openPDF(BuildContext context, File file) => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)),
      );
}
