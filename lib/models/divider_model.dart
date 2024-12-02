import 'block_model.dart';

class DividerBlock extends Block {
  DividerBlock() : super(type: 'divider', content: '');

  @override
  Map<String, dynamic> toJson() {
    return super.toJson();
  }

  factory DividerBlock.fromJson(Map<String, dynamic> json) {
    return DividerBlock();
  }
}