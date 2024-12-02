import 'dart:convert';
import 'block_model.dart';

class Document {
  String title;
  List<Block> blocks;
  List<String> fonts;

  Document({required this.title, required this.blocks, required this.fonts});

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "blocks": blocks.map((block) => block.toJson()).toList(),
      "fonts": fonts,
    };
  }

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      title: json["title"],
      blocks: (json["blocks"] as List).map((block) => Block.fromJson(block)).toList(),
      fonts: List<String>.from(json["fonts"]),
    );
  }
}