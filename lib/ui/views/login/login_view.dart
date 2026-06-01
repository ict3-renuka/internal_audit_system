import 'package:flutter/material.dart';
import 'package:project_one/core/theme/app_colors.dart';
import 'package:project_one/ui/views/login/login_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_text_style.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vModel = Provider.of<LoginViewmodel>(context);
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Container(
          width: width * 0.35,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Welcome Back",
                style: AppTextStyles.title,
              ),
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Email Address",
                  style: AppTextStyles.label,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "e.g. user@gmail.com",
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  hintStyle: AppTextStyles.hint,
                ),
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Password",
                  style: AppTextStyles.label,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: passwordController,
                obscureText: vModel.obscurePassword,
                decoration: InputDecoration(
                  hintText: "••••••••",
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  hintStyle: AppTextStyles.hint,
                  suffixIcon: IconButton(
                    icon: Icon(
                      vModel.obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: () {
                      vModel.togglePasswordVisibility();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.primary,
                    disabledForegroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () async {
                    if (vModel.isLoading) return;
                    bool success = await vModel.login(
                      emailController.text,
                      passwordController.text,
                    );
                    if (success) {
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              "Login Success",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: AppColors.successSnackBar,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );

                        Future.delayed(const Duration(milliseconds: 500), () {
                          Navigator.pushReplacementNamed(context, "/home");
                        });
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            vModel.errorMsg ?? "Error",
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.redAccent.shade100,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  child: vModel.isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  )
                      : const Text("Login"),
                ),
              ),
              const SizedBox(height: 10),
              if (vModel.errorMsg != null)
                Text(
                  vModel.errorMsg!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 10),
              Divider(),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 13,
                      ),
                    ),
                    TextSpan(
                      text: "Contact Admin",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}