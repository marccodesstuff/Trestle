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
      _blocks.add(GestureDetector(
        onTap: () => _showAddImageDialog(),
        child: Container(
          color: Colors.grey,
          height: 100,
          width: double.infinity,
          margin: EdgeInsets.only(right: 16.0), // Add margin to the right
          child: Center(child: Text('Insert image')),
        ),
      ));
    });
  }

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
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        setState(() {
          _blocks.add(Container(
            margin: EdgeInsets.only(right: 16.0), // Add margin to the right
            child: Image.network(imageUrl),
          ));
        });
      } else {
        _showSnackBar('Image cannot be found');
      }
    } on Exception catch (e) {
      _showSnackBar('Image cannot be found');
    }
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