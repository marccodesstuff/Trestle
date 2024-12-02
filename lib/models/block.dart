class Block {
  String id;
  String content;
  String? imageUrl;
  double? width;
  BlockType type;
  BlockAlignment alignment;

  Block({required this.id, required this.content, this.imageUrl, this.width, required this.type, this.alignment = BlockAlignment.left});
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
  justified,
}