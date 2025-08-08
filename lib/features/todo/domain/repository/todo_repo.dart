
import 'package:code_base_assignment/features/todo/domain/entity/todo_entity.dart';
import 'package:code_base_assignment/features/todo/domain/use_cases/todo_use_case.dart';

abstract class TodoRepository {

  Future<void> addTodo(String userId, TodoRequestParam todo);
  Future<List<TodoEntity>> getTodos(String userId);
  Future<void> updateTodo(String userId, TodoEntity todo);
  Future<void> deleteTodo(String userId, String todoId);
  Future<void> deleteAllTodo(String userId);
}
