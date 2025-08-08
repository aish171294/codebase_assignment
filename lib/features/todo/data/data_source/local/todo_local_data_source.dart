import 'package:hive/hive.dart';

import '../../model/todo_model.dart';

class TodoLocalDataSource {
  final Box<TodoModel> todoBox;

  TodoLocalDataSource(this.todoBox);

  Future<void> saveTodoLocally(TodoModel todo) async {
    await todoBox.put(todo.id, todo);
  }

  Future<List<TodoModel>> getAllTodosFromHive() async {
    return todoBox.values.toList();
  }

  Future<void> deleteTodoFromHive(String id) async {
    await todoBox.delete(id);
  }

  Future<void> clearAllTodos() async {
    await todoBox.clear();
  }
}
