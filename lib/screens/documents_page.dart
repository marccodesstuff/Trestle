import 'package:flutter/material.dart';
import '../models/document_model.dart';
import '../models/block_model.dart';

class DocumentPage extends StatefulWidget {
  final Document document;

  DocumentPage({required this.document});

  @override
  _DocumentPageState createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  late List<TextEditingController> _controllers;
  late List<double> _imageWidths;

  @override
  void initState() {
    super.initState();
    _controllers = widget.document.blocks
        .map((block) => TextEditingController(text: block.content))
        .toList();
    _imageWidths = widget.document.blocks
        .map((block) => block.type == BlockType.image ? 150.0 : 0.0)
        .toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.document.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.document.blocks.length,
              itemBuilder: (context, index) {
                final block = widget.document.blocks[index];
                return ListTile(
                  key: ValueKey(block.position),
                  title: block.type == BlockType.text
                      ? TextField(
                          controller: _controllers[index],
                          onChanged: (value) {
                            setState(() {
                              block.content = value;
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Text Block',
                          ),
                        )
                      : GestureDetector(
                          onHorizontalDragUpdate: (details) {
                            setState(() {
                              _imageWidths[index] += details.delta.dx;
                              if (_imageWidths[index] < 50) {
                                _imageWidths[index] = 50;
                              }
                            });
                          },
                          child: Container(
                            width: _imageWidths[index],
                            child: Image.network(block.content),
                          ),
                        ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            widget.document.removeBlock(block);
                            _controllers.removeAt(index);
                            _imageWidths.removeAt(index);
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_upward),
                        onPressed: () {
                          setState(() {
                            if (index > 0) {
                              widget.document.moveBlock(index, index - 1);
                              _swapControllers(index, index - 1);
                              _swapImageWidths(index, index - 1);
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_downward),
                        onPressed: () {
                          setState(() {
                            if (index < widget.document.blocks.length - 1) {
                              widget.document.moveBlock(index, index + 1);
                              _swapControllers(index, index + 1);
                              _swapImageWidths(index, index + 1);
                            }
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    final newBlock = Block.textBlock('New Text Block', widget.document.blocks.length);
                    widget.document.addBlock(newBlock);
                    _controllers.add(TextEditingController(text: newBlock.content));
                    _imageWidths.add(0.0);
                  });
                },
                child: Text('Add Text Block'),
              ),
              ElevatedButton(
                onPressed: () {
                  _showAddImageDialog();
                },
                child: Text('Add Image Block'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _swapControllers(int index1, int index2) {
    final temp = _controllers[index1];
    _controllers[index1] = _controllers[index2];
    _controllers[index2] = temp;
  }

  void _swapImageWidths(int index1, int index2) {
    final temp = _imageWidths[index1];
    _imageWidths[index1] = _imageWidths[index2];
    _imageWidths[index2] = temp;
  }

  void _showAddImageDialog() {
    final TextEditingController urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Image URL'),
          content: TextField(
            controller: urlController,
            decoration: InputDecoration(hintText: 'Image URL'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  final newBlock = Block.imageBlock(urlController.text, widget.document.blocks.length);
                  widget.document.addBlock(newBlock);
                  _controllers.add(TextEditingController(text: newBlock.content));
                  _imageWidths.add(150.0); // Default width for new image blocks
                });
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}