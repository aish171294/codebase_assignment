import 'package:code_base_assignment/features/todo/domain/entity/todo_entity.dart';
import 'package:equatable/equatable.dart';


abstract class TodoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoSuccess extends TodoState {
  @override
  List<Object?> get props => [];
}

class TodoLoaded extends TodoState {
  final List<TodoEntity> todos;

  TodoLoaded(this.todos);

  @override
  List<Object?> get props => [todos];
}

class TodoError extends TodoState {
  final String message;

  TodoError(this.message);

  @override
  List<Object?> get props => [message];
}
