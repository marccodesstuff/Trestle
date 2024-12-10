import 'package:flutter/material.dart';
import '../services/appwrite_service.dart';
import '../models/note.dart';

class DocumentEditorPage extends StatefulWidget {
  final String documentId;
  final String documentTitle;
  final String documentContent;

  const DocumentEditorPage({
    super.key,
    required this.documentId,
    required this.documentTitle,
    required this.documentContent,
  });

  @override
  _DocumentEditorPageState createState() => _DocumentEditorPageState();
}

class _DocumentEditorPageState extends State<DocumentEditorPage> {
  final AppWriteService _appWriteService = AppWriteService();
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.documentTitle);
    _contentController = TextEditingController(text: widget.documentContent);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveDocument() async {
    await _appWriteService.updateNote(
      widget.documentId,
      _titleController.text,
      _contentController.text,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Document saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Enter document title...',
          ),
          style: const TextStyle(color: Colors.black, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveDocument,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _contentController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter document content...',
          ),
          maxLines: null,
        ),
      ),
    );
  }
}