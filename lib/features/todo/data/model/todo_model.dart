

import 'package:code_base_assignment/features/todo/domain/entity/todo_entity.dart';

import 'package:hive/hive.dart';

part 'todo_model.g.dart'; // Required for Hive code generation

@HiveType(typeId: 1) // Choose a unique ID
class TodoModel extends TodoEntity with HiveObjectMixin {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final DateTime createdDate;

  @HiveField(4)
  final DateTime dueDate;

  TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdDate,
    required this.dueDate,
  }) : super(
    id: id,
    title: title,
    description: description,
    createdDate: createdDate,
    dueDate: dueDate,
  );

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      createdDate: DateTime.parse(map['createdDate']),
      dueDate: DateTime.parse(map['dueDate']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdDate': createdDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
    };
  }

  factory TodoModel.fromEntity(TodoEntity todo) => TodoModel(
    id: todo.id,
    title: todo.title,
    description: todo.description,
    createdDate: todo.createdDate,
    dueDate: todo.dueDate,
  );

  TodoEntity toEntity() => TodoEntity(
    id: id,
    title: title,
    description: description,
    createdDate: createdDate,
    dueDate: dueDate,
  );

  TodoModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdDate,
    DateTime? dueDate,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdDate: createdDate ?? this.createdDate,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
