class Note {
  final String title;
  final String content;
  final DateTime timestamp;

  Note({required this.title, required this.content, required this.timestamp});

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'timestamp': timestamp.toIso8601String(),
      };

  static Note fromJson(Map<String, dynamic> json) => Note(
        title: json['title'],
        content: json['content'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}
