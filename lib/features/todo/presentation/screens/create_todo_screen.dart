import 'package:code_base_assignment/core/utils/constants/app_constants.dart';
import 'package:code_base_assignment/core/widgets/common_text_field.dart';
import 'package:code_base_assignment/features/todo/domain/entity/todo_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/themes/color_theme.dart';
import '../../domain/use_cases/todo_use_case.dart';
import '../bloc/todo/todo_bloc.dart';
import '../bloc/todo/todo_event.dart';
import '../bloc/todo/todo_state.dart';

class CreateTodoScreen extends StatefulWidget {
  final TodoEntity? todo;

  const CreateTodoScreen({super.key, this.todo});

  @override
  State<CreateTodoScreen> createState() => _CreateTodoScreenState();
}

class _CreateTodoScreenState extends State<CreateTodoScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  DateTime? dueDate;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.todo?.title ?? '');
    descriptionController = TextEditingController(
      text: widget.todo?.description ?? '',
    );
    dueDate = widget.todo?.dueDate;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _submitTodo(BuildContext context) {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    if (title.isEmpty || description.isEmpty || dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppConstants.allFieldsAreRequired)),
      );
      return;
    }

    if (widget.todo == null) {
      // Create new todo
      final param = TodoRequestParam(
        title: title,
        description: description,
        dueDate: dueDate!,
      );
      context.read<TodoBloc>().add(AddTodo(param));
    } else {
      // Update existing todo
      final updatedTodo = widget.todo!.copyWith(
        title: title,
        description: description,
        dueDate: dueDate!,
      );
      context.read<TodoBloc>().add(UpdateTodo(updatedTodo));
    }

    Navigator.pop(context, true); // optionally notify success
  }


  Future<void> _pickDueDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        dueDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tropicalBlue,
      appBar: AppBar(
        title: Center(
          child: Text(
            widget.todo == null ? AppConstants.createTodo : AppConstants.editTodo,
          ),
        ),
      ),
      body: BlocConsumer<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state is TodoError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is TodoSuccess) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppConstants.todoAddedSuccessfully)),
            );
          }
        },
        builder: (context, state) {
          return AbsorbPointer(
            absorbing: state is TodoLoading,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonTextField(label: AppConstants.title, controller: titleController),
                   SizedBox(height: 18.h),
                  CommonTextField(label: AppConstants.description, controller: descriptionController, maxLines: 3,),
                   SizedBox(height: 18.h),
                  Row(
                    children: [
                      Text(
                        dueDate == null
                            ? AppConstants.selectDueDate
                            : DateFormat('yyyy-MM-dd').format(dueDate!),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _pickDueDate,
                        child: const Text(AppConstants.pickDate),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 18),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: double.infinity,
                      child:
                      ElevatedButton(
                        onPressed: () => _submitTodo(context),
                        child: state is TodoLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                widget.todo == null
                                    ? AppConstants.saveTodo
                                    : AppConstants.updateTodo,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
