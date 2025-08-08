
import 'package:code_base_assignment/core/connectivity/network_info.dart';
import 'package:code_base_assignment/features/todo/data/data_source/local/todo_local_data_source.dart';
import 'package:code_base_assignment/features/todo/domain/entity/todo_entity.dart';
import 'package:code_base_assignment/features/todo/domain/use_cases/todo_use_case.dart';

import '../../domain/repository/todo_repo.dart';
import '../data_source/remote/todo_remote_data_source.dart';
import '../model/todo_model.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource remoteDataSource;
  final TodoLocalDataSource localDataSource;
  final ConnectivityService connectivityService;

  TodoRepositoryImpl({required this.remoteDataSource, required this.localDataSource, required this.connectivityService});

  @override
  Future<void> addTodo(String userId, TodoRequestParam todo) async {
    final tempModel = TodoModel(
      id: '', // Will be generated in data source
      title: todo.title,
      description: todo.description,
      createdDate: DateTime.now(), // Temporary, replaced inside data source
      dueDate: todo.dueDate,
    );


      await remoteDataSource.createTodo(userId, tempModel);
      localDataSource.saveTodoLocally(tempModel);


  }

  @override
  Future<List<TodoModel>> getTodos(String userId) async {
    final connected = await ConnectivityService().isConnected;
    if(!connected) {
     return localDataSource.getAllTodosFromHive();
    } else {
      return remoteDataSource.getTodos(userId);
    }
  }

  @override
  Future<void> updateTodo(String userId, TodoEntity todo) async {
    final todoModel = TodoModel.fromEntity(todo);
    await remoteDataSource.updateTodo(userId, todoModel);
  }

  @override
  Future<void> deleteTodo(String userId, String todoId) async{
    await localDataSource.deleteTodoFromHive(todoId);
    return await remoteDataSource.deleteTodo(userId, todoId);

  }

  @override
  Future<void> deleteAllTodo(String userId) async{
    await localDataSource.clearAllTodos();
    return await remoteDataSource.deleteAllTodo(userId);
  }
}
