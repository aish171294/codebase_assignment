class TodoEntity {
  final String id;
  final String title;
  final String description;
  final DateTime createdDate;
  final DateTime dueDate;

  TodoEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.createdDate,
    required this.dueDate,
  });

  TodoEntity copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdDate,
    DateTime? dueDate,
  }) {
    return TodoEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdDate: createdDate ?? this.createdDate,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
