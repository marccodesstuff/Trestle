import 'dart:convert';
import 'block_model.dart';

class TextBlock extends Block {
  TextBlock({required String type, required String content, required int index})
      : super(type: type, content: content, index: index);

  factory TextBlock.fromJson(Map<String, dynamic> json) {
    return TextBlock(
      type: json["type"],
      content: json["content"],
      index: json["index"],
    );
  }
}