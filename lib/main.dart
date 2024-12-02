import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/blocks_provider.dart';
import 'models/block.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BlocksProvider(),
      child: MaterialApp(
        home: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Block-based Word Processor'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<BlocksProvider>(
              builder: (context, provider, child) {
                return ReorderableListView(
                  onReorder: (oldIndex, newIndex) {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final block = provider.blocks.removeAt(oldIndex);
                    provider.blocks.insert(newIndex, block);
                    provider.notifyListeners();
                  },
                  children: [
                    for (final block in provider.blocks)
                      ListTile(
                        key: ValueKey(block.id),
                        title: block.imageUrl != null
                            ? Stack(
                          children: [
                            GestureDetector(
                              onHorizontalDragUpdate: (details) {
                                double newWidth = (block.width ?? 200.0) + details.delta.dx;
                                if (newWidth > 50) {
                                  provider.resizeImageBlock(block.id, newWidth);
                                }
                              },
                              child: Image.network(
                                block.imageUrl!,
                                width: block.width,
                              ),
                            ),
                            Positioned(
                              left: 0,
                              top: 0,
                              bottom: 0,
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onHorizontalDragUpdate: (details) {
                                  double newWidth = (block.width ?? 200.0) + details.delta.dx;
                                  if (newWidth > 50) {
                                    provider.resizeImageBlock(block.id, newWidth);
                                  }
                                },
                                child: Container(
                                  width: 10,
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              bottom: 0,
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onHorizontalDragUpdate: (details) {
                                  double newWidth = (block.width ?? 200.0) + details.delta.dx;
                                  if (newWidth > 50) {
                                    provider.resizeImageBlock(block.id, newWidth);
                                  }
                                },
                                child: Container(
                                  width: 10,
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                          ],
                        )
                            : Text(block.content),
                        onTap: () {
                          if (block.imageUrl == null) {
                            _controller.text = block.content;
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Edit Block'),
                                content: TextField(
                                  controller: _controller,
                                  onSubmitted: (value) {
                                    provider.updateBlock(block.id, value);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            );
                          }
                        },
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            provider.deleteBlock(block.id);
                          },
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Add Text Block',
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        Provider.of<BlocksProvider>(context, listen: false)
                            .addTextBlock(value);
                        _controller.clear();
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      Provider.of<BlocksProvider>(context, listen: false)
                          .addTextBlock(_controller.text);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _imageController,
                    decoration: InputDecoration(
                      labelText: 'Add Image URL',
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        Provider.of<BlocksProvider>(context, listen: false)
                            .addImageBlock(value);
                        _imageController.clear();
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (_imageController.text.isNotEmpty) {
                      Provider.of<BlocksProvider>(context, listen: false)
                          .addImageBlock(_imageController.text);
                      _imageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}