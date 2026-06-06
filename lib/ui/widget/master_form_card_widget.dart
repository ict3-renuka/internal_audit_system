import 'package:flutter/material.dart';
import 'package:project_one/core/theme/app_colors.dart';

class MasterFormCardWidget extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget button;

  const MasterFormCardWidget({
    super.key,
    required this.title,
    required this.children,
    required this.button,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 30),

          ...children,

          const SizedBox(height: 30),
          button,
        ],
      ),
    );
  }
}