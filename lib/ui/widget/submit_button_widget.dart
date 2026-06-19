import 'package:flutter/material.dart';
import 'package:project_one/core/theme/app_colors.dart';

class SubmitButton extends StatelessWidget {
  final bool isLoading;
  final double width;
  final VoidCallback onSubmit;
  final String buttonText;

  const SubmitButton({
    super.key,
    required this.isLoading,
    required this.width,
    required this.onSubmit,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onSubmit,
        icon: isLoading
            ? SizedBox(
          width: width * 0.01,
          height: width * 0.01,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : const Icon(Icons.send_outlined, color: Colors.white, size: 18),
        label: Text(
          buttonText,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.02,
            vertical: width * 0.012,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
    );
  }
}