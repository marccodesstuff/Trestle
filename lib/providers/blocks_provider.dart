import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/block.dart';

class BlocksProvider with ChangeNotifier {
  final List<Block> _blocks = [];
  final Uuid _uuid = const Uuid();

  List<Block> get blocks => _blocks;

  void addTextBlock(String content, BlockAlignment alignment) {
    try {
      final block = Block(
        id: _uuid.v4(),
        content: content,
        type: BlockType.text,
        alignment: alignment,
      );
      _blocks.add(block);
      notifyListeners();
    } catch (e) {
      // Handle error
      print('Error adding text block: $e');
    }
  }

  void addDividerBlock() {
    try {
      final block = Block(id: _uuid.v4(), content: '', type: BlockType.divider);
      _blocks.add(block);
      notifyListeners();
    } catch (e) {
      // Handle error
      print('Error adding divider block: $e');
    }
  }

  void addImageBlock(String imageUrl) {
    try {
      final block = Block(
          id: _uuid.v4(),
          content: '',
          imageUrl: imageUrl,
          width: 200.0,
          type: BlockType.image);
      _blocks.add(block);
      notifyListeners();
    } catch (e) {
      // Handle error
      print('Error adding image block: $e');
    }
  }

  void updateBlock(String id, String content) {
    final index = _blocks.indexWhere((block) => block.id == id);
    if (index != -1) {
      _blocks[index].content = content;
      notifyListeners();
    }
  }

  void resizeImageBlock(String id, double width) {
    final index = _blocks.indexWhere((block) => block.id == id);
    if (index != -1) {
      _blocks[index].width = width;
      notifyListeners();
    }
  }

  void deleteBlock(String id) {
    _blocks.removeWhere((block) => block.id == id);
    notifyListeners();
  }
}
