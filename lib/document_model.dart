import 'dart:convert';
import 'package:flutter/material.dart';

class Document {
  String title;
  List<String> blocks;
  List<String> fonts;

  Document({required this.title, required this.blocks, required this.fonts});

  Map<String, dynamic> toJson()
  {
    return
    {
      "title": title,
      "block": blocks,
      "fonts": fonts,
    };
  }

  factory Document.fromJson(Map<String, dynamic> json)
  {
    return Document
    (
      title: json["title"],
      blocks: List<String>.from(json["blocks"]),
      fonts: List<String>.from(json["fonts"]),
    );
  }
}