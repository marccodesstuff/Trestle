import 'block_model.dart';

class ImageBlock extends Block {
  String imageUrl;

  ImageBlock({required String type, required String content, required int index, required this.imageUrl})
      : super(type: type, content: content, index: index);

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
      index: json['index'],
      imageUrl: json['imageUrl'],
    );
  }
}