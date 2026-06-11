import 'package:flutter/material.dart';
import 'package:project_one/core/theme/app_colors.dart';
import 'package:project_one/core/theme/app_text_style.dart';
import 'submit_button_widget.dart';

class SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;
  final double width;
  final VoidCallback? onSubmit;
  final bool isLoading;

  const SectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.children,
    required this.width,
    this.onSubmit,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(width * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 12),
              Text(title, style: AppTextStyles.subTitle),
            ],
          ),
          const SizedBox(height: 32),
          ...children,
          const SizedBox(height: 40),
          if (onSubmit != null)
            SubmitButton(
              isLoading: isLoading,
              width: width,
              onSubmit: onSubmit!,
            ),
        ],
      ),
    );
  }
}