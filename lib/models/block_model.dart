class Block {
  String type;
  String content;
  int index;

  Block({required this.type, required this.content, required this.index});

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "content": content,
      "index": index,
    };
  }

  factory Block.fromJson(Map<String, dynamic> json) {
    return Block(
      type: json["type"],
      content: json["content"],
      index: json["index"],
    );
  }
}