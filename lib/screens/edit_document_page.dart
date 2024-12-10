import 'package:flutter/material.dart';
import '../services/appwrite_service.dart';
import '../widgets/toolbar.dart';
import 'dart:convert';
import '../models/image_block.dart';
import 'package:http/http.dart' as http;

class EditDocumentPage extends StatefulWidget {
  final String documentId;

  const EditDocumentPage({super.key, required this.documentId});

  @override
  _EditDocumentPageState createState() => _EditDocumentPageState();
}

class _EditDocumentPageState extends State<EditDocumentPage> {
  final AppWriteService _appWriteService = AppWriteService();
  late TextEditingController _titleController;
  List<Widget> _blocks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDocument();
  }

  Future<void> _fetchDocument() async {
    final document = await _appWriteService.fetchDocumentById(widget.documentId);
    if (document != null) {
      setState(() {
        _titleController = TextEditingController(text: document['title']);
        _blocks = _parseBlocks(document['content']);
        _isLoading = false;
      });
    }
  }

  List<Widget> _parseBlocks(String content) {
    final List<dynamic> blockData = jsonDecode(content);
    return blockData.map<Widget>((block) {
      if (block['type'] == 'text') {
        return TextField(
          controller: TextEditingController(text: block['content']),
          decoration: const InputDecoration(hintText: 'Enter text here'),
        );
      } else if (block['type'] == 'image') {
        return ImageBlock(imageUrl: block['url']);
      }
      return Container();
    }).toList();
  }

  void _addTextBlock() {
    setState(() {
      _blocks.add(TextField(
        controller: TextEditingController(),
        decoration: const InputDecoration(
          hintText: 'Enter text here',
          contentPadding: EdgeInsets.zero,
        ),
      ));
    });
  }

  void _addImageBlock() {
    setState(() {
      _blocks.add(const ImageBlock());
    });
  }

  void _updateDocument() async {
    await _appWriteService.saveOldDocument(_titleController.text, _blocks);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Document saved successfully')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isLoading
            ? const CircularProgressIndicator()
            : TextField(
                controller: _titleController,
                decoration: const InputDecoration(hintText: 'Document Title'),
              ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _updateDocument,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ReorderableListView(
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final Widget item = _blocks.removeAt(oldIndex);
                  _blocks.insert(newIndex, item);
                });
              },
              children: _blocks
                  .asMap()
                  .map((index, block) => MapEntry(
                      index,
                      IntrinsicHeight(
                        key: ValueKey(index),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: block,
                              ),
                            ),
                            ReorderableDragStartListener(
                              index: index,
                              child: const Icon(Icons.drag_handle),
                            ),
                          ],
                        ),
                      )))
                  .values
                  .toList(),
            ),
      bottomNavigationBar: Toolbar(
        onAddTextBlock: _addTextBlock,
        onAddImageBlock: _addImageBlock,
      ),
    );
  }
}