import 'package:quittr/features/journal/domain/entities/journal_entry.dart';

class JournalEntryModel extends JournalEntry {
  const JournalEntryModel({
    super.id,
    required super.title,
    required super.description,
    required super.createdAt,
  });

  factory JournalEntryModel.fromMap(Map<String, dynamic> map) {
    return JournalEntryModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'created_at': createdAt.toIso8601String(),
    };
  }

  JournalEntryModel copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? createdAt,
  }) {
    return JournalEntryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
