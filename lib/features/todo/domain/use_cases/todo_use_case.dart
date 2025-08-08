

import 'package:code_base_assignment/features/todo/domain/entity/todo_entity.dart';

import '../repository/todo_repo.dart';

class AddTodoUseCase {
  final TodoRepository repository;

  AddTodoUseCase(this.repository);

  Future<void> call(String userId, TodoRequestParam todo) {
    return repository.addTodo(userId, todo);
  }
}

class TodoRequestParam {
  final String title;
  final String description;
  final DateTime dueDate;

  TodoRequestParam({
    required this.title,
    required this.description,
    required this.dueDate,
  });

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "dueDate": dueDate.toIso8601String(),
  };
}

class GetTodosUseCase {
  final TodoRepository repository;

  GetTodosUseCase(this.repository);

  Future<List<TodoEntity>> call(String userId) {
    return repository.getTodos(userId);
  }
}

class UpdateTodoUseCase {
  final TodoRepository repository;

  UpdateTodoUseCase(this.repository);

  Future<void> call(String userId, TodoEntity todo) {
    return repository.updateTodo(userId, todo);
  }
}

class DeleteTodoUseCase {
  final TodoRepository repository;

  DeleteTodoUseCase(this.repository);

  Future<void> call(String userId, String todoId) {
    return repository.deleteTodo(userId, todoId);
  }
}

class DeleteALlTodoUseCase {
  final TodoRepository repository;

  DeleteALlTodoUseCase(this.repository);

  Future<void> call(String userId) {
    return repository.deleteAllTodo(userId);
  }
}
