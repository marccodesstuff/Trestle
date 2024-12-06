import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/blocks_provider.dart';
import '../models/block.dart';
import '../providers/theme_provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Block-based Word Processor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
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
                        title: _buildBlockContent(context, block, provider),
                        onTap: () {
                          if (block.type == BlockType.text) {
                            _controller.text = block.content;
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  AlertDialog(
                                    title: const Text('Edit Block'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: _controller,
                                          onSubmitted: (value) {
                                            provider.updateBlock(
                                                block.id, value);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        _buildToolbar(context, block),
                                      ],
                                    ),
                                  ),
                            );
                          }
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
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
                    decoration: const InputDecoration(
                      labelText: 'Add Text Block',
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        _showAlignmentDialog(context, value);
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      _showAlignmentDialog(context, _controller.text);
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
                    decoration: const InputDecoration(
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
                  icon: const Icon(Icons.add),
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
                    child: const Text('Add Divider Block'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAlignmentDialog(BuildContext context, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Alignment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: BlockAlignment.values.map((alignment) {
              return ListTile(
                title: Text(alignment
                    .toString()
                    .split('.')
                    .last),
                onTap: () {
                  Provider.of<BlocksProvider>(context, listen: false)
                      .addTextBlock(content, alignment);
                  Navigator.of(context).pop();
                  _controller.clear();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildBlockContent(BuildContext context, Block block,
      BlocksProvider provider) {
    Alignment textAlign;
    switch (block.alignment) {
      case BlockAlignment.center:
        textAlign = Alignment.center;
        break;
      case BlockAlignment.right:
        textAlign = Alignment.centerRight;
        break;
      case BlockAlignment.left:
      default:
        textAlign = Alignment.centerLeft;
        break;
    }

    switch (block.type) {
      case BlockType.text:
        return Container(
          alignment: textAlign,
          child: MarkdownBody(
            data: block.content,
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
          ),
        );
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
        return const Divider();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildToolbar(BuildContext context, Block block) {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.format_bold),
            onPressed: () {
              _applyMarkdownFormatting('**');
            },
          ),
          IconButton(
            icon: const Icon(Icons.format_italic),
            onPressed: () {
              _applyMarkdownFormatting('_');
            },
          ),
          IconButton(
            icon: const Icon(Icons.format_align_left),
            onPressed: () {
              _applyTextAlignment(context, block, BlockAlignment.left);
            },
          ),
          IconButton(
            icon: const Icon(Icons.format_align_center),
            onPressed: () {
              _applyTextAlignment(context, block, BlockAlignment.center);
            },
          ),
          IconButton(
            icon: const Icon(Icons.format_align_right),
            onPressed: () {
              _applyTextAlignment(context, block, BlockAlignment.right);
            },
          ),
          IconButton(
            icon: const Icon(Icons.format_list_bulleted),
            onPressed: () {
              _toggleUnorderedList();
            },
          ),
        ],
      ),
    );
  }

  void _toggleUnorderedList() {
    final text = _controller.text;
    if (text.startsWith('- ')) {
      _controller.text = text.substring(2);
    } else {
      _controller.text = '- $text';
    }
    _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length));
  }

  void _applyMarkdownFormatting(String markdownSymbol) {
    final text = _controller.text;
    final selection = _controller.selection;
    if (selection.isValid) {
      final selectedText = text.substring(selection.start, selection.end);
      final newText = text.replaceRange(
        selection.start,
        selection.end,
        '$markdownSymbol$selectedText$markdownSymbol',
      );
      _controller.value = _controller.value.copyWith(
        text: newText,
        selection: TextSelection.collapsed(
            offset: selection.end + markdownSymbol.length * 2),
      );
    }
  }

  void _applyTextAlignment(BuildContext context, Block block,
      BlockAlignment alignment) {
    Provider.of<BlocksProvider>(context, listen: false).updateBlock(
        block.id, _controller.text);
    block.alignment = alignment;
    Provider.of<BlocksProvider>(context, listen: false).notifyListeners();
  }
}