import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'models/document_model.dart';
import 'models/block_model.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/document.json');
}

Future<File> saveDocument(Document document) async {
  final file = await _localFile;
  return file.writeAsString(jsonEncode(document.toJson()));
}

Future<Document> loadDocument() async {
  try {
    final file = await _localFile;
    final contents = await file.readAsString();
    return Document.fromJson(jsonDecode(contents));
  } catch (e) {
    // If encountering an error, return an empty document
    return Document(title: 'New Document', blocks: [Block(type: 'text', content: '')], fonts: ['Roboto']);
  }
}