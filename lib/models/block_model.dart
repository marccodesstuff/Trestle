enum BlockType {
  text,
  image,
}

class Block {
  final BlockType type;
  String content; // For text blocks, this will be the text content. For image blocks, this will be the image URL.
  int position; // Position of the block in the document

  Block({
    required this.type,
    required this.content,
    required this.position,
  });

  // Factory method to create a text block
  factory Block.textBlock(String content, int position) {
    return Block(
      type: BlockType.text,
      content: content,
      position: position,
    );
  }

  // Factory method to create an image block
  factory Block.imageBlock(String imageUrl, int position) {
    return Block(
      type: BlockType.image,
      content: imageUrl,
      position: position,
    );
  }
}