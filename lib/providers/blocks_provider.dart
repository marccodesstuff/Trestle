import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/block.dart';

class BlocksProvider with ChangeNotifier {
  final List<Block> _blocks = [];
  final Uuid _uuid = Uuid();

  List<Block> get blocks => _blocks;

  void addTextBlock(String content) {
    final block = Block(id: _uuid.v4(), content: content);
    _blocks.add(block);
    notifyListeners();
  }

  void addImageBlock(String imageUrl) {
    final block = Block(id: _uuid.v4(), content: '', imageUrl: imageUrl, width: 200.0);
    _blocks.add(block);
    notifyListeners();
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