class Document {
  String title;
  List<String> blocks;

  Document({required this.title, required this.blocks});

  Map<String, dynamic> toJson() => {
    'title': title,
    'blocks': blocks,
  };

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      title: json['title'],
      blocks: List<String>.from(json['blocks']),
    );
  }
}