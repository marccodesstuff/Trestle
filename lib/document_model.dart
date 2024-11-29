class Document {
  String title;
  List<String> blocks;
  List<String> fonts;

  Document({required this.title, required this.blocks, required this.fonts});

  Map<String, dynamic> toJson() => {
    'title': title,
    'blocks': blocks,
  };

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      title: json['title'],
      blocks: List<String>.from(json['blocks']),
      fonts: List<String>.from(json['fonts']),
    );
  }
}