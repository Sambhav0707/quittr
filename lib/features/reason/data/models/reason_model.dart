class ReasonModel {
  final int? id;
  final String reason;
  final DateTime createdAt;

  ReasonModel({
    this.id,
    required this.reason,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reason': reason,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory ReasonModel.fromMap(Map<String, dynamic> map) {
    return ReasonModel(
      id: map['id'],
      reason: map['reason'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  ReasonModel copyWith({
    int? id,
    String? reason,
    DateTime? createdAt,
  }) {
    return ReasonModel(
      id: id ?? this.id,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
    );
  }
} 