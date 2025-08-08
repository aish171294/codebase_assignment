import 'package:code_base_assignment/features/todo/domain/entity/todo_entity.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/use_cases/todo_use_case.dart';

abstract class TodoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTodos extends TodoEvent {

  LoadTodos();
}

class AddTodo extends TodoEvent {
  final TodoRequestParam todo;
  AddTodo(this.todo);
}


class UpdateTodo extends TodoEvent {
  final TodoEntity todo;
  UpdateTodo(this.todo);
}

class DeleteTodo extends TodoEvent {
  final String todoId;
  DeleteTodo(this.todoId);
}

class DeleteAllTodo extends TodoEvent {
  DeleteAllTodo();
}




