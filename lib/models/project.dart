class Project {
  final String id;
  String name;
  String description;
  final DateTime createdAt;
  DateTime modifiedAt;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.modifiedAt,
  });
}
