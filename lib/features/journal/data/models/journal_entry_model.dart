class JournalEntry {
  final int? id;
  final String title;
  final String description;
  final DateTime createdAt;

  JournalEntry({
    this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  JournalEntry copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? createdAt,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
} 