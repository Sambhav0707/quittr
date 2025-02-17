import 'package:quittr/features/meditate/domain/entities/qoutes.dart';

class QoutesModel extends Qoutes {
  QoutesModel({required int id, required String text}) : super(id, text);

  factory QoutesModel.fromJson(Map<String, dynamic> json) {
    return QoutesModel(
      id: json['id'] as int,
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
    };
  }

  QoutesModel copyWith({
    int? id,
    String? text,
  }) {
    return QoutesModel(
      id: id ?? this.id,
      text: text ?? this.text,
    );
  }
}
