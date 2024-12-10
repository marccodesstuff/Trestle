class Note {
  final String id;
  final String title;
  final String content;
  final DateTime dateCreated;
  final DateTime dateUpdated;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.dateCreated,
    required this.dateUpdated,
  });

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['\$id'],
      title: map['title'],
      content: map['content'],
      dateCreated: DateTime.parse(map['date_created']),
      dateUpdated: DateTime.parse(map['date_updated']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'date_created': dateCreated.toIso8601String(),
      'date_updated': dateUpdated.toIso8601String(),
    };
  }
}