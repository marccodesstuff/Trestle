import 'block_model.dart';

class Document {
  String title;
  List<Block> blocks;

  Document({
    required this.title,
    required this.blocks,
  });

  // Add a block to the document
  void addBlock(Block block) {
    blocks.add(block);
    _reorderBlocks();
  }

  // Remove a block from the document
  void removeBlock(Block block) {
    blocks.remove(block);
    _reorderBlocks();
  }

  // Move a block to a new position
  void moveBlock(int oldIndex, int newIndex) {
    if (oldIndex < 0 || oldIndex >= blocks.length || newIndex < 0 || newIndex >= blocks.length) {
      return;
    }
    final block = blocks.removeAt(oldIndex);
    blocks.insert(newIndex, block);
    _reorderBlocks();
  }

  // Reorder blocks based on their position
  void _reorderBlocks() {
    for (int i = 0; i < blocks.length; i++) {
      blocks[i].position = i;
    }
  }
}