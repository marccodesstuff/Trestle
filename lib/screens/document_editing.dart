import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/appwrite_service.dart'; // Import the AppWriteService

class DocumentEditorPage extends StatefulWidget {
  final String documentTitle;

  const DocumentEditorPage({super.key, required this.documentTitle});

  @override
  _DocumentEditorPageState createState() => _DocumentEditorPageState();
}

class _DocumentEditorPageState extends State<DocumentEditorPage> {
  final List<Widget> _blocks = [];
  late TextEditingController _titleController;
  final AppWriteService _appWriteService = AppWriteService(); // Initialize AppWriteService

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.documentTitle);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _addTextBlock() {
    setState(() {
      _blocks.add(TextField(
        controller: TextEditingController(), // Assign a controller
        decoration: const InputDecoration(
          hintText: 'Enter text here',
          contentPadding: EdgeInsets.zero, // Remove padding around text
        ),
      ));
    });
  }

  void _addImageBlock() {
    setState(() {
      _blocks.add(const ImageBlock());
    });
  }

  void _saveDocument() async {
    await _appWriteService.saveNewDocument(_titleController.text, _blocks);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Document saved successfully')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _titleController,
          decoration: const InputDecoration(hintText: 'Document Title'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveDocument, // Call the save function
          ),
        ],
      ),
      body: ReorderableListView(
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
                  key: ValueKey(index), // Add a unique key for each widget
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0), // Add padding
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
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.text_fields),
              onPressed: _addTextBlock,
            ),
            IconButton(
              icon: const Icon(Icons.image),
              onPressed: _addImageBlock,
            ),
          ],
        ),
      ),
    );
  }
}

class ImageBlock extends StatefulWidget {
  const ImageBlock({super.key});

  @override
  _ImageBlockState createState() => _ImageBlockState();
}

class _ImageBlockState extends State<ImageBlock> {
  String? _imageUrl;
  bool _isLoading = false;
  double _imageHeight = 100;
  Alignment _alignment = Alignment.center;

  String? get imageUrl => _imageUrl;

  void _showAddImageDialog() {
    TextEditingController imageUrlController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Insert Image URL'),
          content: TextField(
            controller: imageUrlController,
            decoration: const InputDecoration(hintText: 'Enter image URL'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Insert'),
              onPressed: () {
                Navigator.of(context).pop();
                _insertImage(imageUrlController.text);
              },
            ),
          ],
        );
      },
    );
  }

  void _insertImage(String imageUrl) async {
    if (imageUrl.isEmpty) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        setState(() {
          _imageUrl = imageUrl;
          _isLoading = false;
        });
      } else {
        _showSnackBar('Image cannot be found');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      _showSnackBar('Image cannot be found');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _showImageOptionsDialog() {
    TextEditingController newImageUrlController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Image Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Height'),
              Slider(
                value: _imageHeight,
                min: 50,
                max: 300,
                divisions: 50,
                label: _imageHeight.round().toString(),
                onChanged: (value) {
                  setState(() {
                    _imageHeight = value;
                  });
                },
              ),
              DropdownButton<Alignment>(
                value: _alignment,
                items: const [
                  DropdownMenuItem(
                    value: Alignment.centerLeft,
                    child: Text('Left'),
                  ),
                  DropdownMenuItem(
                    value: Alignment.center,
                    child: Text('Center'),
                  ),
                  DropdownMenuItem(
                    value: Alignment.centerRight,
                    child: Text('Right'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _alignment = value!;
                  });
                },
              ),
              TextField(
                controller: newImageUrlController,
                decoration: const InputDecoration(hintText: 'Enter new image URL'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                if (newImageUrlController.text.isNotEmpty) {
                  _insertImage(newImageUrlController.text);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _imageUrl == null
          ? GestureDetector(
              onTap: _showAddImageDialog,
              child: Container(
                color: Colors.grey,
                height: 100,
                width: double.infinity,
                child: Center(
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Insert image'),
                ),
              ),
            )
          : GestureDetector(
              onTap: _showImageOptionsDialog,
              child: Container(
                height: _imageHeight,
                alignment: _alignment,
                child: Image.network(_imageUrl!),
              ),
            ),
    );
  }
}
