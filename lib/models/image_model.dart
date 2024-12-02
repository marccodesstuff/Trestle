import 'block_model.dart';

class ImageBlock extends Block {
  String imageUrl;

  ImageBlock({required super.type, required super.content, required this.imageUrl});

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['imageUrl'] = imageUrl;
    return json;
  }

  factory ImageBlock.fromJson(Map<String, dynamic> json) {
    return ImageBlock(
      type: json['type'],
      content: json['content'],
      imageUrl: json['imageUrl'],
    );
  }
}