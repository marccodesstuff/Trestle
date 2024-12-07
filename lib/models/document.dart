import './block.dart';

class Document {
  final String id;
  List<Block> blocks;

  Document({required this.id, required this.blocks});

  Map<String, dynamic> toJson() => {
    'id': id,
    'blocks': blocks.map((block) => block.toJson()).toList(),
  };
}