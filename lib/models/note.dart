import 'tag.dart';

class Note {
  final String id;
  final String projectId;
  String title;
  String description;
  final DateTime createdAt;
  DateTime modifiedAt;
  List<Tag> tags;

  Note({
    required this.id,
    required this.projectId,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.modifiedAt,
    List<Tag>? tags,
  }) : tags = tags ?? [];

  String get excerpt {
    if (description.isEmpty) return '';
    return description.length > 120 ? '${description.substring(0, 120)}...' : description;
  }
}
