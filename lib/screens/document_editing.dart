import 'package:flutter/material.dart';

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
      _blocks.add(TextBlock(key: UniqueKey(), initialText: ''));
    });
  }

  void _addImageBlock(String imageUrl) {
    setState(() {
      _blocks.add(ImageBlock(key: UniqueKey(), imageUrl: imageUrl));
    });
  }

  void _showAddImageDialog() {
    final TextEditingController _urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Image'),
          content: TextField(
            controller: _urlController,
            decoration: const InputDecoration(hintText: 'Enter image URL'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addImageBlock(_urlController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final Widget block = _blocks.removeAt(oldIndex);
      _blocks.insert(newIndex, block);
    });
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
      ),
      body: ReorderableListView(
        padding: const EdgeInsets.all(16.0),
        children: _blocks.map((block) {
          return Container(
            key: block.key,
            child: block,
          );
        }).toList(),
        onReorder: _onReorder,
      ),
      bottomNavigationBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: BottomAppBar(
          color: Theme.of(context).colorScheme.surface,
          elevation: 8,
          child: Container(
            height: 56, // Adjust the height as needed
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.text_format),
                  onPressed: _addTextBlock,
                ),
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: _showAddImageDialog,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TextBlock extends StatefulWidget {
  final String initialText;

  const TextBlock({Key? key, required this.initialText}) : super(key: key);

  @override
  _TextBlockState createState() => _TextBlockState();
}

class _TextBlockState extends State<TextBlock> {
  String _alignment = 'left';

  void _showAlignmentDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select Text Alignment'),
              DropdownButton<String>(
                value: _alignment,
                items: const [
                  DropdownMenuItem(value: 'left', child: Text('Left')),
                  DropdownMenuItem(value: 'center', child: Text('Center')),
                  DropdownMenuItem(value: 'right', child: Text('Right')),
                ],
                onChanged: (value) {
                  setState(() {
                    _alignment = value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Align(
              alignment: _alignment == 'left'
                  ? Alignment.centerLeft
                  : _alignment == 'right'
                      ? Alignment.centerRight
                      : Alignment.center,
              child: TextField(
                textAlign: _alignment == 'left'
                    ? TextAlign.left
                    : _alignment == 'right'
                        ? TextAlign.right
                        : TextAlign.center,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter text here...',
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: _showAlignmentDialog,
            ),
          ),
        ],
      ),
    );
  }
}

class ImageBlock extends StatefulWidget {
  final String imageUrl;

  const ImageBlock({Key? key, required this.imageUrl}) : super(key: key);

  @override
  _ImageBlockState createState() => _ImageBlockState();
}

class _ImageBlockState extends State<ImageBlock> {
  double _imageHeight = 200.0;
  String _alignment = 'center';

  void _showSizeAdjustDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Adjust Image Size'),
              Slider(
                value: _imageHeight,
                min: 100.0,
                max: 400.0,
                divisions: 6,
                label: '${_imageHeight.round()}',
                onChanged: (value) {
                  setState(() {
                    _imageHeight = value;
                  });
                },
              ),
              const Text('Select Image Alignment'),
              DropdownButton<String>(
                value: _alignment,
                items: const [
                  DropdownMenuItem(value: 'left', child: Text('Left')),
                  DropdownMenuItem(value: 'center', child: Text('Center')),
                  DropdownMenuItem(value: 'right', child: Text('Right')),
                ],
                onChanged: (value) {
                  setState(() {
                    _alignment = value!;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Done'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showSizeAdjustDialog,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Align(
          alignment: _alignment == 'left'
              ? Alignment.centerLeft
              : _alignment == 'right'
                  ? Alignment.centerRight
                  : Alignment.center,
          child: Image.network(
            widget.imageUrl,
            height: _imageHeight,
            errorBuilder: (context, error, stackTrace) {
              return const Text('Failed to load image');
            },
          ),
        ),
      ),
    );
  }
}