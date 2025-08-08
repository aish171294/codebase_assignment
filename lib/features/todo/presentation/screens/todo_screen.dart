import 'package:code_base_assignment/core/routes/route_names.dart';
import 'package:code_base_assignment/core/utils/constants/app_constants.dart';
import 'package:code_base_assignment/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:code_base_assignment/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../core/utils/themes/color_theme.dart';
import '../bloc/todo/todo_bloc.dart';
import '../bloc/todo/todo_event.dart';
import '../bloc/todo/todo_state.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    context.read<TodoBloc>().add(LoadTodos());
    _refreshController.refreshCompleted();
  }

  // void userLoggedOut() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setBool('isLoggedIn', false);
  //   context.read<TodoBloc>().add(DeleteAllTodo());
  // }


  @override
  void initState() {
    context.read<TodoBloc>().add(LoadTodos());
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tropicalBlue,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(AppConstants.yourTodos),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                context.read<TodoBloc>().add(DeleteAllTodo());
                context.read<AuthBloc>().add(LogoutRequested());
                // userLoggedOut();
                Navigator.pushReplacementNamed(context, RouteNames.login);
              },
              child: const Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodoLoaded) {
            final today = DateTime.now();

            return SmartRefresher(
              controller: _refreshController,
              onRefresh: _onRefresh,
              header: const WaterDropHeader(),
              child: state.todos.isEmpty
                  ? const Center(child: Text(AppConstants.noTodosFound))
                  : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: state.todos.length,
                itemBuilder: (context, index) {
                  final todo = state.todos[index];
                  final isDueToday = todo.dueDate.year == today.year &&
                      todo.dueDate.month == today.month &&
                      todo.dueDate.day == today.day;

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(
                        todo.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDueToday ? Colors.red : Colors.black,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(todo.description),
                          if (isDueToday)
                            const Padding(
                              padding: EdgeInsets.only(top: 4.0),
                              child: Text(
                                "Hey! complete this task by today",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.edit, size: 16),
                              Text(DateFormat('yyyy-MM-dd').format(todo.dueDate)),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              context.read<TodoBloc>().add(DeleteTodo(todo.id));
                            },
                          ),
                        ],
                      ),
                      onTap: () async {
                        final updated = Navigator.pushNamed(
                          context,
                          RouteNames.create_todo,
                          arguments: todo, // Passing todo object here
                        );
                        if (updated == true) {
                          context.read<TodoBloc>().add(LoadTodos());
                        }
                      },
                    ),
                  );
                },
              ),
            );
          } else if (state is TodoError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, RouteNames.create_todo);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

