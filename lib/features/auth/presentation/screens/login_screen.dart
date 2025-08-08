import 'package:code_base_assignment/core/utils/constants/app_constants.dart';
import 'package:code_base_assignment/core/utils/themes/color_theme.dart';
import 'package:code_base_assignment/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:code_base_assignment/features/auth/presentation/bloc/auth_event.dart';
import 'package:code_base_assignment/features/auth/presentation/bloc/auth_state.dart';
import 'package:code_base_assignment/features/auth/presentation/screens/register_screen.dart';
import 'package:code_base_assignment/features/todo/domain/entity/todo_entity.dart';
import 'package:code_base_assignment/features/todo/presentation/screens/todo_screen.dart';
import 'package:code_base_assignment/features/todo/presentation/widget/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';



class LoginScreen extends StatelessWidget {
  final TodoEntity? todo;
  LoginScreen({super.key, this.todo});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void userLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
  }

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
              userLoggedIn();
              ScaffoldMessenger.of(context).showSnackBar(

                const SnackBar(content: Text(AppConstants.loginSuccessful)),
              );
                Navigator.push(context, MaterialPageRoute(builder: (context) => TodoScreen(),));
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen(),));
              },
            );
          },
        ),
      ),
    );
  }
}


