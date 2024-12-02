import 'dart:convert';
import 'block_model.dart';

class TextBlock extends Block {
  TextBlock({required super.type, required super.content});

  factory TextBlock.fromJson(Map<String, dynamic> json) {
    return TextBlock(
      type: json["type"],
      content: json["content"],
    );
  }
}