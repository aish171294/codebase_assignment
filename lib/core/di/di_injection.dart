import 'package:code_base_assignment/core/connectivity/network_info.dart';
import 'package:code_base_assignment/features/auth/data/data_source/local/user_local_data_source.dart';
import 'package:code_base_assignment/features/auth/data/data_source/remote/user_remote_data_source.dart';
import 'package:code_base_assignment/features/auth/data/model/user_model.dart';
import 'package:code_base_assignment/features/auth/data/repository_impl/user_repo_impl.dart';
import 'package:code_base_assignment/features/auth/domain/repository/user_repo.dart';
import 'package:code_base_assignment/features/auth/domain/usecase/login_user_usecase.dart';
import 'package:code_base_assignment/features/auth/domain/usecase/register_user_usecase.dart';
import 'package:code_base_assignment/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../features/todo/data/data_source/local/todo_local_data_source.dart';
import '../../features/todo/data/data_source/remote/todo_remote_data_source.dart';
import '../../features/todo/data/model/todo_model.dart';
import '../../features/todo/data/repository_impl/todo_repo_impl.dart';
import '../../features/todo/domain/repository/todo_repo.dart';
import '../../features/todo/domain/use_cases/todo_use_case.dart';
import '../../features/todo/presentation/bloc/todo/todo_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<ConnectivityService>(() => ConnectivityService());

  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  //user box not need use secure storage/ shared pref.
  // sl.registerLazySingleton<Box<UserModel>>(() => Hive.box<UserModel>('userBox'));

  sl.registerLazySingleton<Box<TodoModel>>(
    () => Hive.box<TodoModel>('todoBox'),
  );

  /// TODO AUTH FEATURE

  sl.registerFactory(
    () => AuthBloc(
      loginUserUseCase: sl(),
      registerUserUseCase: sl(),
      // logoutUserUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUserUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUserUseCase(sl()));
  // sl.registerLazySingleton(() => LogoutUserUseCase(sl()));

  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSource(auth: sl(), firestore: sl()),
  );
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSource(sl()),
  );

  /// TODO FEATURE

  // Bloc
  sl.registerFactory(
    () => TodoBloc(
      addTodoUseCase: sl(),
      deleteTodoUseCase: sl(),
      deleteALlTodoUseCase: sl(),
      updateTodoUseCase: sl(),
      getTodosUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => AddTodoUseCase(sl()));
  sl.registerLazySingleton(() => DeleteTodoUseCase(sl()));
  sl.registerLazySingleton(() => DeleteALlTodoUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTodoUseCase(sl()));
  sl.registerLazySingleton(() => GetTodosUseCase(sl()));

  // Repository
  sl.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(
      remoteDataSource: sl<TodoRemoteDataSource>(),
      localDataSource: sl<TodoLocalDataSource>(),
      connectivityService: sl<ConnectivityService>(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<TodoRemoteDataSource>(
    () => TodoRemoteDataSource(firestore: sl<FirebaseFirestore>()),
  );
  sl.registerLazySingleton<TodoLocalDataSource>(
    () => TodoLocalDataSource(sl()),
  );
}
