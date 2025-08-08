import 'package:code_base_assignment/core/utils/constants/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/constants/app_images.dart';
import '../../../../core/widgets/common_button.dart';
import '../../../../core/widgets/custom_input_field.dart';

class RegisterForm extends StatelessWidget {
  final String actionButtonText;
  final VoidCallback onSubmit;
  final VoidCallback onToggle;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isLoading;
  final bool isLogin;

  const RegisterForm({
    super.key,
    required this.actionButtonText,
    required this.onSubmit,
    required this.onToggle,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    this.isLoading = false,
    this.isLogin = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          // ✅ Top image stays fixed
          SizedBox(
            height: 250.h,
            child: Center(
              child: Image.asset(AppImages.daily_task, fit: BoxFit.contain),
            ),
          ),
          // ✅ Scrollable form fields
          SizedBox(height: 50.h),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  CustomInputField(
                    label: AppConstants.name,
                    icon: Icons.person,
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 18.h),

                  CustomInputField(
                    label: AppConstants.email,
                    icon: Icons.email_outlined,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 18.h),

                  CustomInputField(
                    label: AppConstants.password,
                    icon: Icons.lock_outline,
                    controller: passwordController,
                    isObscure: true,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 18.h),

                  CustomInputField(
                    label: AppConstants.confirmPassword,
                    icon: Icons.lock_outline,
                    controller: confirmPasswordController,
                    isObscure: true,
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 32.h),

                  CommonButton(
                    text: actionButtonText,
                    isLoading: isLoading,
                    onPressed: onSubmit,
                  ),
                  SizedBox(height: 16.h),

                  TextButton(
                    onPressed: onToggle,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: isLogin
                                ? AppConstants.dontHaveAnAccount
                                : AppConstants.alreadyHaveAnAccount,
                          ),
                          TextSpan(
                            text: isLogin
                                ? AppConstants.register
                                : AppConstants.login,
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
