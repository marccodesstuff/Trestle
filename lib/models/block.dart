class Block {
  String id;
  String content;
  String? imageUrl;
  double? width;
  BlockType type;

  Block({required this.id, required this.content, this.imageUrl, this.width, required this.type});
}

enum BlockType {
  text,
  image,
  divider,
}