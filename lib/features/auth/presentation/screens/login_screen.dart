import 'package:code_base_assignment/core/routes/route_names.dart';
import 'package:code_base_assignment/core/utils/constants/app_constants.dart';
import 'package:code_base_assignment/core/utils/themes/color_theme.dart';
import 'package:code_base_assignment/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:code_base_assignment/features/auth/presentation/bloc/auth_event.dart';
import 'package:code_base_assignment/features/auth/presentation/bloc/auth_state.dart';
import 'package:code_base_assignment/features/todo/domain/entity/todo_entity.dart';
import 'package:code_base_assignment/features/todo/presentation/widget/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class LoginScreen extends StatefulWidget {
  final TodoEntity? todo;
  LoginScreen({super.key, this.todo});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.tropicalBlue,
        body: BlocConsumer<AuthBloc, AuthState> (
          listener: (context, state) {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }

            if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content:
                // Text(S.of(context).loginSuccessful))
                Text(AppConstants.loginSuccessful)),
              );
              Navigator.pushNamed(context, RouteNames.todo);
            }
          },
          builder: (context, state) {
            return LoginForm(
              actionButtonText: AppConstants.login,
              emailController: emailController,
              passwordController: passwordController,
              isLogin: true,
              isLoading: state is AuthLoading,
              onSubmit: () {
                context.read<AuthBloc>().add(LoginSubmitted(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                ));
              },
              onToggle: () {
                Navigator.pushNamed(context, RouteNames.register);
              },
            );
          },
        ),
      ),
    );
  }
}


