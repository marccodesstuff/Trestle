class Block {
  final String id;
  BlockType type;
  String content;
  BlockAlignment alignment;
  String? imageUrl;
  double? width;

  Block({
    required this.id,
    required this.content,
    this.imageUrl,
    this.width,
    required this.type,
    this.alignment = BlockAlignment.left
  });
}

enum BlockType {
  text,
  image,
  divider,
}

enum BlockAlignment
{
  left,
  center,
  right,
}