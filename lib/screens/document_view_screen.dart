import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

class DocumentViewScreen extends StatelessWidget {
  static String routeName = "/documentViewScreen";

  const DocumentViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as DocumentViewScreenArguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(args.fileName),
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return args.fileType == "pdf"
                ? PdfView(path: snapshot.data!)
                : Image.file(File(snapshot.data!));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
        future: getDocumentData(args),
      ),
    );
  }
}

Future<String> getDocumentData(DocumentViewScreenArguments arguments) async {
  final Directory directory = await getApplicationSupportDirectory();
  File file =
      File("${directory.path}/${arguments.fileName}+'.'+${arguments.fileType}");
  if (await file.exists()) {
    return file.path;
  } else {
    final Response response = await get(Uri.parse(arguments.fileUrl));
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }
}

class DocumentViewScreenArguments {
  final String fileUrl;
  final String fileName;
  final String fileType;

  DocumentViewScreenArguments({
    required this.fileUrl,
    required this.fileName,
    required this.fileType,
  });
}
