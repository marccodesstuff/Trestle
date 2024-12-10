import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DocumentEditorPage extends StatefulWidget {
  final String documentTitle;

  const DocumentEditorPage({super.key, required this.documentTitle});

  @override
  _DocumentEditorPageState createState() => _DocumentEditorPageState();
}

class _DocumentEditorPageState extends State<DocumentEditorPage> {
  final List<Widget> _blocks = [];
  late TextEditingController _titleController;

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
        decoration: InputDecoration(hintText: 'Enter text here'),
      ));
    });
  }

  void _addImageBlock() {
    setState(() {
      _blocks.add(ImageBlock());
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _titleController,
          decoration: InputDecoration(hintText: 'Document Title'),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveDocument,
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
        children: _blocks.map((block) {
          return ListTile(
            key: ValueKey(block),
            title: block,
          );
        }).toList(),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.text_fields),
              onPressed: _addTextBlock,
            ),
            IconButton(
              icon: Icon(Icons.image),
              onPressed: _addImageBlock,
            ),
          ],
        ),
      ),
    );
  }

  void _saveDocument() {
    // Implement save document logic here
  }
}

class ImageBlock extends StatefulWidget {
  @override
  _ImageBlockState createState() => _ImageBlockState();
}

class _ImageBlockState extends State<ImageBlock> {
  String? _imageUrl;
  bool _isLoading = false;
  double _imageHeight = 100;
  Alignment _alignment = Alignment.center;

  void _showAddImageDialog() {
    TextEditingController imageUrlController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Insert Image URL'),
          content: TextField(
            controller: imageUrlController,
            decoration: InputDecoration(hintText: 'Enter image URL'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Insert'),
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showImageOptionsDialog() {
    TextEditingController newImageUrlController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Image Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Height'),
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
                items: [
                  DropdownMenuItem(
                    child: Text('Left'),
                    value: Alignment.centerLeft,
                  ),
                  DropdownMenuItem(
                    child: Text('Center'),
                    value: Alignment.center,
                  ),
                  DropdownMenuItem(
                    child: Text('Right'),
                    value: Alignment.centerRight,
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
                decoration: InputDecoration(hintText: 'Enter new image URL'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
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
                      ? CircularProgressIndicator()
                      : Text('Insert image'),
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