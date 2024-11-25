import 'package:flutter/material.dart';
import 'document_model.dart'; // Updated import

class EditDocumentPage extends StatefulWidget {
  final Document document;

  EditDocumentPage({required this.document});

  @override
  _EditDocumentPageState createState() => _EditDocumentPageState();
}

class _EditDocumentPageState extends State<EditDocumentPage> {
  late TextEditingController _titleController;
  late List<TextEditingController> _blockControllers;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.document.title);
    _blockControllers = widget.document.blocks.map((block) => TextEditingController(text: block)).toList();
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (var controller in _blockControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addBlock() {
    setState(() {
      _blockControllers.add(TextEditingController());
    });
  }

  void _removeBlock(int index) {
    setState(() {
      _blockControllers.removeAt(index).dispose();
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    setState(() {
      final item = _blockControllers.removeAt(oldIndex);
      _blockControllers.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Document'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              // Save the edited document
              Navigator.pop(context, Document(
                title: _titleController.text,
                blocks: _blockControllers.map((controller) => controller.text).toList(),
              ));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ReorderableListView(
                onReorder: _onReorder,
                children: [
                  for (int index = 0; index < _blockControllers.length; index++)
                    ListTile(
                      key: ValueKey(index),
                      title: TextField(
                        controller: _blockControllers[index],
                        decoration: InputDecoration(labelText: 'Block ${index + 1}'),
                        maxLines: null,
                        expands: false,
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _removeBlock(index),
                      ),
                    ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _addBlock,
              child: Text('Add Block'),
            ),
          ],
        ),
      ),
    );
  }
}