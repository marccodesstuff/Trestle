import 'package:flutter/material.dart';
import 'document_model.dart'; // Updated import

class EditDocumentPage extends StatefulWidget {
  final Document document;

  const EditDocumentPage({super.key, required this.document});

  @override
  _EditDocumentPageState createState() => _EditDocumentPageState();
}

class _EditDocumentPageState extends State<EditDocumentPage> {
  late TextEditingController _titleController;
  late List<TextEditingController> _blockControllers;
  late List<String> _selectedFonts;

  final List<String> _availableFonts = ['Arial', 'Courier', 'Times New Roman'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.document.title);
    _blockControllers = widget.document.blocks.map((block) => TextEditingController(text: block)).toList();
    _selectedFonts = widget.document.fonts;
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
      _selectedFonts.add(_availableFonts.first);
    });
  }

  void _removeBlock(int index) {
    setState(() {
      _blockControllers.removeAt(index).dispose();
      _selectedFonts.removeAt(index);
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    setState(() {
      final item = _blockControllers.removeAt(oldIndex);
      final font = _selectedFonts.removeAt(oldIndex);
      _blockControllers.insert(newIndex, item);
      _selectedFonts.insert(newIndex, font);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Document'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // Save the edited document
              Navigator.pop(context, Document(
                title: _titleController.text,
                blocks: _blockControllers.map((controller) => controller.text).toList(),
                fonts: _selectedFonts,
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
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ReorderableListView(
                onReorder: _onReorder,
                children: [
                  for (int index = 0; index < _blockControllers.length; index++)
                    ListTile(
                      key: ValueKey(index),
                      title: Column(
                        children: [
                          TextField(
                            controller: _blockControllers[index],
                            decoration: InputDecoration(labelText: 'Block ${index + 1}'),
                            maxLines: null,
                            expands: false,
                            style: TextStyle(fontFamily: _selectedFonts[index]),
                          ),
                          DropdownButton<String>(
                            value: _selectedFonts[index],
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedFonts[index] = newValue!;
                              });
                            },
                            items: _availableFonts.map<DropdownMenuItem<String>>((String font) {
                              return DropdownMenuItem<String>(
                                value: font,
                                child: Text(font),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _removeBlock(index),
                      ),
                    ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _addBlock,
              child: const Text('Add Block'),
            ),
          ],
        ),
      ),
    );
  }
}