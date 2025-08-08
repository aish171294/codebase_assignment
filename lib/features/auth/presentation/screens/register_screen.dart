import 'package:code_base_assignment/core/routes/route_names.dart';
import 'package:code_base_assignment/core/utils/constants/app_constants.dart';
import 'package:code_base_assignment/core/utils/themes/color_theme.dart';
import 'package:code_base_assignment/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:code_base_assignment/features/auth/presentation/bloc/auth_event.dart';
import 'package:code_base_assignment/features/auth/presentation/bloc/auth_state.dart';
import 'package:code_base_assignment/features/todo/presentation/widget/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.tropicalBlue,
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }

            if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: Text(AppConstants.registrationSuccessful)),
              );
              Navigator.pushNamed(context, RouteNames.login);
            }
          },
          builder: (context, state) {
            return RegisterForm(
              actionButtonText: AppConstants.register,
              nameController: nameController,
              emailController: emailController,
              passwordController: passwordController,
              confirmPasswordController: confirmPasswordController,
              isLogin: false,
              isLoading: state is AuthLoading,
              onSubmit: () {
                context.read<AuthBloc>().add(RegisterSubmitted(
                  name: nameController.text.trim(),
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                  confirmPassword: confirmPasswordController.text.trim(),
                ));
              },
              onToggle: () {
                Navigator.pushNamed(context, RouteNames.login);
              },
            );
          },
        ),
      ),
    );
  }
}
