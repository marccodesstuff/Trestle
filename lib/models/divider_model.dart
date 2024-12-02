import 'block_model.dart';

class DividerBlock extends Block {
  DividerBlock({required int index}) : super(type: 'divider', content: '', index: index);

  @override
  Map<String, dynamic> toJson() {
    return super.toJson();
  }

  factory DividerBlock.fromJson(Map<String, dynamic> json) {
    return DividerBlock(index: json["index"]);
  }
}