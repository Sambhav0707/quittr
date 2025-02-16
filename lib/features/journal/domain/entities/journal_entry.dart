import 'package:equatable/equatable.dart';

class JournalEntry extends Equatable {
  final int? id;
  final String title;
  final String description;
  final DateTime createdAt;

  const JournalEntry({
    this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, description, createdAt];
}
