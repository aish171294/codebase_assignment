import 'package:code_base_assignment/features/auth/presentation/screens/login_screen.dart';
import 'package:code_base_assignment/features/auth/presentation/screens/register_screen.dart';
import 'package:code_base_assignment/features/todo/domain/entity/todo_entity.dart';
import 'package:code_base_assignment/features/todo/presentation/screens/create_todo_screen.dart';
import 'package:code_base_assignment/features/todo/presentation/screens/todo_screen.dart';
import 'package:flutter/material.dart';
import 'route_names.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case RouteNames.register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());

      case RouteNames.todo:
        return MaterialPageRoute(builder: (_) => TodoScreen());


      case RouteNames.create_todo:
        final args = settings.arguments as TodoEntity?;
        return MaterialPageRoute(
          builder: (_) => CreateTodoScreen(todo: args,)
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('No route defined')),
          ),
        );
    }
  }
}
