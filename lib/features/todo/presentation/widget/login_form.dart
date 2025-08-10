import 'package:code_base_assignment/core/utils/constants/app_constants.dart';
import 'package:code_base_assignment/core/widgets/custom_input_field.dart';
import 'package:code_base_assignment/core/widgets/language_toggle_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/constants/app_images.dart';
import '../../../../core/widgets/common_button.dart';

class LoginForm extends StatefulWidget {
  final String actionButtonText;
  final VoidCallback onSubmit;
  final VoidCallback onToggle;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final bool isLogin;

  const LoginForm({
    super.key,
    this.actionButtonText = '',
    required this.onSubmit,
    required this.onToggle,
    required this.emailController,
    required this.passwordController,
    this.isLoading = false,
    this.isLogin = true,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
      child: Column(
        children: [
          // Fixed Image at the top
          SizedBox(
            height: 150.h,
            child: Center(
              child: Image.asset(AppImages.daily_task, fit: BoxFit.contain),
            ),
          ),
          SizedBox(height: 50.h),
          LanguageToggleButton(),
          SizedBox(height: 30.h),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomInputField(
                    label: AppConstants.email.tr(),
                    icon: Icons.email_outlined,
                    controller: widget.emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 18.h),

                  CustomInputField(
                    label: AppConstants.password.tr(),
                    icon: Icons.lock_outline,
                    controller: widget.passwordController,
                    isObscure: true,
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 35.h),

                  CommonButton(
                    text: widget.actionButtonText,
                    isLoading: widget.isLoading,
                    onPressed: widget.onSubmit,
                  ),
                  SizedBox(height: 16.h),
                  TextButton(
                    onPressed: widget.onToggle,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: widget.isLogin
                                ? AppConstants.dontHaveAnAccount.tr()
                                : AppConstants.alreadyHaveAnAccount.tr(),
                          ),
                          TextSpan(
                            text: widget.isLogin
                                ? AppConstants.register.tr()
                                : AppConstants.login.tr(),
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
