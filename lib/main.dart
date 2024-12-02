import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/blocks_provider.dart';
import 'models/block.dart'; // This is not being used since the application starts at the document immediately instead of the home screen
import 'providers/theme_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BlocksProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeProvider.themeMode,
            home: HomeScreen(),
          );
        },
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
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
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
                        title: _buildBlockContent(block, provider),
                        onTap: () {
                          if (block.type == BlockType.text) {
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Provider.of<BlocksProvider>(context, listen: false)
                          .addDividerBlock();
                    },
                    child: Text('Add Divider Block'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlockContent(Block block, BlocksProvider provider) {
    switch (block.type) {
      case BlockType.text:
        return Text(block.content);
      case BlockType.image:
        return Stack(
          children: [
            GestureDetector(
              onHorizontalDragUpdate: (details) {
                double newWidth = (block.width ?? 200.0) + details.delta.dx;
                if (newWidth > 50) {
                  provider.resizeImageBlock(block.id, newWidth);
                }
              },
              child: Center(
                child: Image.network(
                  block.imageUrl!,
                  width: block.width,
                ),
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
        );
      case BlockType.divider:
        return Divider();
      default:
        return SizedBox.shrink();
    }
  }
}