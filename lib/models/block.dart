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

  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'imageUrl': imageUrl,
    'width': width,
    'type': type.toString().split('.').last,
    'alignment': alignment.toString().split('.').last,
  };
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