import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/todo_use_case.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final AddTodoUseCase addTodoUseCase;
  final GetTodosUseCase getTodosUseCase;
  final UpdateTodoUseCase updateTodoUseCase;
  final DeleteTodoUseCase deleteTodoUseCase;
  final DeleteALlTodoUseCase deleteALlTodoUseCase;

  TodoBloc({
    required this.addTodoUseCase,
    required this.getTodosUseCase,
    required this.updateTodoUseCase,
    required this.deleteTodoUseCase,
    required this.deleteALlTodoUseCase,
  }) : super(TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<UpdateTodo>(_onUpdateTodo);
    on<DeleteTodo>(_onDeleteTodo);
    on<DeleteAllTodo>(_onDeleteAllTodo);
    init();
  }

  void init() {
    add(LoadTodos()); // ✅ Proper way to trigger logic
  }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    log("Todo called");
    emit(TodoLoading());
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        emit(TodoError("User not logged in"));
        return;
      }
      final todos = await getTodosUseCase(userId);
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError("Failed to load todos"));
    }
  }

  Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        emit(TodoError("User not logged in"));
        return;
      }

      await addTodoUseCase(userId, event.todo); // ✅ pass both

      emit(TodoSuccess());

      add(LoadTodos());
    } catch (e) {
      emit(TodoError("Failed to add todo"));
    }
  }

  Future<void> _onUpdateTodo(UpdateTodo event, Emitter<TodoState> emit) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        emit(TodoError("User not logged in"));
        return;
      }

      await updateTodoUseCase(userId, event.todo); // ✅ pass both

      add(LoadTodos());
    } catch (e) {
      emit(TodoError("Failed to update todo"));
    }
  }

  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        emit(TodoError("User not logged in"));
        return;
      }

      await deleteTodoUseCase(userId, event.todoId); // ✅ pass both

      add(LoadTodos());
    } catch (e) {
      emit(TodoError("Failed to delete todo"));
    }
  }



  FutureOr<void> _onDeleteAllTodo(DeleteAllTodo event, Emitter<TodoState> emit) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        emit(TodoError("User not logged in"));
        return;
      }

      await deleteALlTodoUseCase.call(userId); // ✅ pass both
    } catch (e) {
      emit(TodoError("Failed to delete todo"));
    }
  }
}

