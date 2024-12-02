import 'dart:convert';

class Block {
  String type;
  String content;

  Block({required this.type, required this.content});

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "content": content,
    };
  }

  factory Block.fromJson(Map<String, dynamic> json) {
    return Block(
      type: json["type"],
      content: json["content"],
    );
  }
}